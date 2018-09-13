//
//  User.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/25/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import Foundation
import Firebase

class User {
    static fileprivate var following: [String: Artist] = [:]
    
   static func follow(_ artist: Artist) {
        following.updateValue(artist, forKey: artist.artistName)
    
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
                        let artist = searchData.results[0]
                        let artistRef = Api.followingRef.child(artist.artistName.lowercased())
                        
                        artistRef.setValue(artist.toAnyObject())
                    }
                } catch let err {
                    print("Err", err)
                }
                }.resume()
        }
    }
    
    static func unfollow(_ artist: Artist) {
        following.removeValue(forKey: artist.artistName)
        
        let artistRef = Api.followingRef.child(artist.artistName.lowercased())
        artistRef.removeValue()
    }
    
    static func unfollow(_ artist: String) {
        following.removeValue(forKey: artist)
    }
    
    static func isFollowing(_ artist: Artist) -> Bool {
        return following[artist.artistName] != nil
    }
    
    static func isFollowing(_ artist: String) -> Bool {
        return following[artist] != nil
    }
    
    static func getArtists() -> [Artist] {
        var artists: [Artist] = []
        for (_, value) in following {
            artists.append(value)
        }
        return artists
    }
}
