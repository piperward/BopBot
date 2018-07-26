//
//  Track.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/25/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import Foundation

struct Result: Codable {
    let resultCount: Int?
    let results: [Track]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case results = "results"
    }
}

struct Track: Codable {
    let wrapperType: String?
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let releaseDate: Date?
    
    private enum CodingKeys: String, CodingKey {
        case wrapperType
        case trackName
        case artistName
        case collectionName
        case artworkUrl60
        case artworkUrl100
        case releaseDate
    }
}
