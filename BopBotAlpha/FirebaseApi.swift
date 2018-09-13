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
}


