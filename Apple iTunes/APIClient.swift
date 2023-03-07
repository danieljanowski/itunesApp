//
//  APIClient.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 05/03/2023.
//

import Foundation

class APIClient {
    
    func call(url: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let urlComponents = URLComponents(string: url)
        let request = URLRequest(url: (urlComponents?.url)!)
        
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
}
