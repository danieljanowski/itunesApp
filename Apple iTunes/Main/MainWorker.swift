//
//  MainWorker.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 05/03/2023.
//

import Foundation

class MainWorker {
    let apiClient = APIClient()
    
    func searchiTunes(searchPhrase: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        
        let urlString = "https://itunes.apple.com/search?term="
        let searchUrlWithQuery = urlString + searchPhrase.lowercased()
        
        apiClient.call(url: searchUrlWithQuery, completion: completion )
    }
}
