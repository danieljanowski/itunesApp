//
//  MainInteractor.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 05/03/2023.
//

import Foundation

class MainInteractor {
    
    let worker = Worker()
    let presenter = MainPresenter()
    
    func searchiTunes(searchPhrase: String) {
        self.worker.searchiTunes(searchPhrase: searchPhrase) { (data, response, error) in
            if let error = error {
                print(error)
//                self?.showError(with: error)
            } else if let data = data {
                self.parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonTracks = try? decoder.decode(Tracks.self, from: json)
        {
            let tracks = jsonTracks.results
            let filteredTracks = tracks.filter({$0.artistId != nil && $0.trackName != nil})
            if filteredTracks.isEmpty { presenter.showNoResultsNotification() }
            presenter.reloadTableData(filteredTracks: filteredTracks)
        }
    }
}
