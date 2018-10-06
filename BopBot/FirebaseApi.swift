//
//  FirebaseApi.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 9/13/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import Foundation

import Foundation
import Firebase
struct Api {
    static let followingRef = Database.database().reference(withPath: "following")

    static func observeFollowingArtists(completion: @escaping ([CodableArtist]) -> Void) {
        self.followingRef.observeSingleEvent(of: .value, with: {snapshot in
            let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
            
            //This group will keep track of the number of locks still pending
            let group = DispatchGroup()
            var newArtists: [CodableArtist] = []
            
            for groupKey in groupKeys {
                group.enter()
                self.followingRef.child(groupKey).observeSingleEvent(of: .value, with: { snapshot in
                    if let artist = CodableArtist(snapshot: snapshot) {
                        newArtists.append(artist)
                    }
                    group.leave()
                })
            }
            
            group.notify(queue: .main) {
                completion(newArtists)
            }
        })
    }
    
    static func observeFollowingNames(completion: @escaping ([Artist]) -> Void) {
        self.followingRef.observe(.value, with: {snapshot in
            let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
            var artists: [Artist] = []
            
            for groupKey in groupKeys {
                artists.append(Artist(artistName: groupKey))
            }
            completion(artists)
        })
    }
    
    static func followAction(_ artist: Artist) {
        if let album = artist.latestRelease() {
            let artistId = album.artistId!
            
            guard let lookUpUrl = URL(string: "https://itunes.apple.com/lookup?id=" + "\(artistId)") else { return }
            
            URLSession.shared.dataTask(with: lookUpUrl) { (data, response, error)
                in
                
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let searchData = try decoder.decode(ArtistLookupResult.self, from: data)
                    
                    DispatchQueue.main.sync {
                        var artist = searchData.results[0]
                        artist.artworkUrl100 = album.artworkUrl100
                        artist.albumName = album.collectionName
                        artist.releaseDate = album.releaseDate
                        let artistRef = self.followingRef.child(artist.artistName.lowercased())
                        
                        artistRef.setValue(artist.toAnyObject())
                    }
                } catch let err {
                    print("[Error FirebaseApi.swift]", err)
                }
                }.resume()
        }
    }
    
    static func unfollowAction(_ artist: Artist) {
        let artistRef = self.followingRef.child(artist.artistName.lowercased())
        artistRef.removeValue()
    }
}


