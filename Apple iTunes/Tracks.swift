//
//  Tracks.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 01/03/2023.
//

import Foundation

struct Tracks: Codable {
    var results: [Track]
}

struct Track: Codable {
    var artistName: String
    var trackName: String
}
