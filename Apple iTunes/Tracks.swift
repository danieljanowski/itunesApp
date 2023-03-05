//
//  Tracks.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 01/03/2023.
//

import Foundation

struct Tracks: Codable {
    let results: [Track]
}

struct Track: Codable {
    let artistName: String
    let trackName: String?
    let artistId: Int?
}
