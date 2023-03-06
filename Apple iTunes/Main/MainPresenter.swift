//
//  MainPresenter.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 05/03/2023.
//

import Foundation

protocol MainPresenterLogic {
    func showNoResultsNotification()
    func showErrorNotification(with error: Error)
    func reloadTableData(filteredTracks: [Track])
}

class MainPresenter: MainPresenterLogic {
    
    var viewController: ViewController?
    
    func showNoResultsNotification(){
        viewController?.showNotification(title: "Search", message:  "No results found", actionTitle: "OK")
    }
    
    func showErrorNotification(with error: Error) {
        let message = "There was a problem loading the feed. \(error.localizedDescription)"
        viewController?.showNotification(title: "Loading error", message: message, actionTitle: "OK")
    }
    
    func reloadTableData(filteredTracks: [Track]) {
        viewController?.reloadTableData(filteredTracksData: filteredTracks)
    }
}
