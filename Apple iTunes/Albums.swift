//
//  Albums.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 05/03/2023.
//

import Foundation

struct Albums: Decodable {
    let results: [Album]
}

struct Album: Decodable {
    let artistId: Int
    let artistName: String
    let collectionName: String?
    let artworkUrl100: String?
}
