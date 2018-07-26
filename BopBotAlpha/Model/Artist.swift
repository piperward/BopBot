//
//  Artist.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/25/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import Foundation

struct Artist {
    let artistName: String
    let collectionNames: [String]?
    let tracksFromSeparateCollections: [Track]?
    
    init(artistName: String, collections tracks: [Track]? = nil) {
        self.artistName = artistName
        if tracks != nil {
            self.tracksFromSeparateCollections = tracks
            self.collectionNames = []
            for track in tracks! {
                collectionNames?.append(track.collectionName!)
            }
        }
        else {
            tracksFromSeparateCollections = []
            collectionNames = []
        }
    }
    
    func latestRelease() -> Track? {
        if let tracks = tracksFromSeparateCollections {
            var latest = tracks.first
            for (index, _) in tracks.enumerated() {
                if (index+1) < tracks.count {
                    let nextTrack = tracks[index+1]
                    if nextTrack.releaseDate! > latest!.releaseDate! {
                        latest = nextTrack
                    }
                }
            }
            return latest
        }
        
        return nil
    }
}
