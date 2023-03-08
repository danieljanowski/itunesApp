//
//  DetailInteractor.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 07/03/2023.
//

import Foundation

protocol DetailInteractorLogic {
    func loadAlbums(artistId: Int)
    func parse(json: Data) -> [Album]
    func loadAlbumArt(urlString: String)
}

class DetailIntercator: DetailInteractorLogic {
    
    var worker: Worker?
    var presenter: DetailPresenter?
    
    func loadAlbums(artistId: Int) {
        worker?.loadAlbums(artistId: artistId) { [weak self] (data, response, error) in
            if let error = error {
                self?.presenter?.showErrorNotification(with: error)
            }
            guard let dataToParse = data else { return }
            let albums = self?.parse(json: dataToParse)
//            TODO load first album art
//            if !albums.isEmpty, let unwrappedUrl = albums[0].artworkUrl100 {
////                guard let unwrappedUrl = self.albums[0].artworkUrl100 else { return } //presenter
//                self.loadAlbumArt(urlString: unwrappedUrl)
//            }
        }
    }
    
    func parse(json: Data) -> [Album] {
        let decoder = JSONDecoder()
        var albums = [Album]()
        if let jsonTracks = try? decoder.decode(Albums.self, from: json)
        {
            albums = jsonTracks.results.filter({$0.collectionName != nil && $0.artworkUrl100 != nil})
            if albums.isEmpty { presenter?.showNoResultsNotification() }
            presenter?.reloadTableData(filteredAlbums: albums)
        }
        return albums
    }
    
    func loadAlbumArt(urlString: String) {
        worker?.loadAlbumArt(urlString: urlString) {
            [weak self] (data, response, error) in
            if let error = error {
                    self?.presenter?.showErrorNotification(with: error)
                }

            guard let imageData = data else { return }
            self?.presenter?.showAlbumArt(imageData: imageData)
        }
    }
    
}
