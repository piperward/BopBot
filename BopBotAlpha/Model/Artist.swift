//
//  Artist.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/25/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import Foundation
import Firebase

struct Artist {
    let artistName: String
    var albums: [Album]?
    
    init(artistName: String, albums: [Album]? = nil) {
        self.artistName = artistName
        self.albums = albums
    }
    
    func latestRelease() -> Album? {
        if let tempAlbums = self.albums {
            var latest = tempAlbums.first
            for (index, _) in tempAlbums.enumerated() {
                if (index+1) < tempAlbums.count {
                    let nextCollection = tempAlbums[index+1]
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let nextAlbumReleaseDate = formatter.date(from: nextCollection.releaseDate!)
                    let latestReleaseDate = formatter.date(from: (latest?.releaseDate!)!)
                    if nextAlbumReleaseDate! > latestReleaseDate! {
                        latest = nextCollection
                    }
                }
            }
            return latest
        }
        
        return nil
    }
}
