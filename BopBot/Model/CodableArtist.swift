//
//  CodableArtist.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 8/4/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import Foundation
import Firebase

struct ArtistLookupResult: Codable {
    let resultCount: Int?
    let results: [CodableArtist]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case results = "results"
    }
}

struct CodableArtist: Codable {
//    let artistId: String
    let amgArtistId: Int
    let artistName: String
    let artistLinkUrl: String
    let artistType: String
    var albums: [Album]? = nil
    var artworkUrl100: String? = nil
    var albumName: String? = nil
    var releaseDate: String? = nil
    
    private enum CodingKeys: String, CodingKey {
//        case artistId
        case amgArtistId
        case artistName
        case artistLinkUrl
        case artistType
        case artworkUrl100
        case albumName
        case releaseDate
    }
    
    func toAnyObject() -> Any {
        return [
//            "artistId": artistId,
            "amgArtistId": amgArtistId,
            "artistName": artistName,
            "artistLinkUrl": artistLinkUrl,
            "artistType": artistType,
            "albumName": albumName,
            "artworkUrl100": artworkUrl100,
            "releaseDate": releaseDate
        ]
    }
}

extension CodableArtist {
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
//            let artistId = value["artistId"] as? String,
            let amgArtistId = value["amgArtistId"] as? Int,
            let artistName = value["artistName"] as? String,
            let artistType = value["artistType"] as? String,
            let artistLinkUrl = value["artistLinkUrl"] as? String,
            let albumName = value["albumName"] as? String,
            let artworkUrl100 = value["artworkUrl100"] as? String,
            let releaseDate = value["releaseDate"] as? String
            else {return nil}
        
        
        self.artistName = artistName
        self.amgArtistId = amgArtistId
//        self.artistId = artistId
        self.artistType = artistType
        self.artistLinkUrl = artistLinkUrl
        self.albumName = albumName
        self.artworkUrl100 = artworkUrl100
        self.releaseDate = releaseDate
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
