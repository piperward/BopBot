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
    
        Api.followAction(artist)
    }
    
    static func unfollow(_ artist: Artist) {
        following.removeValue(forKey: artist.artistName.lowercased())
        
        Api.unfollowAction(artist)
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
