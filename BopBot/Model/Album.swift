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
    let results: [Album]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case results = "results"
    }
}

struct Album: Codable {
    let artistId: Int?
    let collectionId: Int?
    let artistName: String?
    let collectionName: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let artworkUrl100: String?
    let releaseDate: String?
    let collectionType: String?
    
    private enum CodingKeys: String, CodingKey {
        case artistId
        case collectionId
        case artistName
        case collectionName
        case artistViewUrl
        case collectionViewUrl
        case artworkUrl100
        case releaseDate
        case collectionType
    }
}
