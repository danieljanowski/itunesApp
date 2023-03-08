//
//  DetailPresenter.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 07/03/2023.
//

import Foundation

protocol DetailPresenterLogic {
    func showNoResultsNotification()
    func showErrorNotification(with error: Error)
    func reloadTableData(filteredAlbums: [Album])
    func showAlbumArt(imageData: Data)
}

class DetailPresenter: DetailPresenterLogic {
    
    var viewController: DetailViewController?

    func showNoResultsNotification(){
        viewController?.showNotification(title: "Search", message:  "No albums found for this artist", actionTitle: "OK")
    }
    
    func showErrorNotification(with error: Error) {
        let message = "There was a problem loading the feed. \(error.localizedDescription)"
        viewController?.showNotification(title: "Loading error", message: message, actionTitle: "OK")
    }
    
    func reloadTableData(filteredAlbums: [Album]) {
        viewController?.reloadTableData(filteredAlbumsData: filteredAlbums)
    }
    
    func showAlbumArt(imageData: Data) {
        viewController?.showImageData(data: imageData)
    }
}
