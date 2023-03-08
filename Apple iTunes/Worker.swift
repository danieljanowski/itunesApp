//
//  Worker.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 05/03/2023.
//

import Foundation

protocol WorkerLogic {
    func searchiTunes(searchPhrase: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void
    
    func loadAlbums(artistId: Int, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void
    
    func loadAlbumArt(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void
}

class Worker {
    let apiClient = APIClient()
    
    func searchiTunes(searchPhrase: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        
        let urlString = "https://itunes.apple.com/search?term="
        let searchUrlWithQuery = urlString + searchPhrase.lowercased()
        
        apiClient.call(url: searchUrlWithQuery, completion: completion )
    }
    
    func loadAlbums(artistId: Int, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let urlString = "https://itunes.apple.com/lookup?id=\(artistId)&entity=album"
        
        apiClient.call(url: urlString, completion: completion)
    }
    
    func loadAlbumArt(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        apiClient.call(url: urlString, completion: completion)
    }
}
