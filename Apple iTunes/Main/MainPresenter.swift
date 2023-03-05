//
//  MainPresenter.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 05/03/2023.
//

import Foundation

class MainPresenter {
    
    var viewController = ViewController()
    
    func showNoResultsNotification(){
        viewController.showNoResultsNotification()
    }
    
    func reloadTableData(filteredTracks: [Track]) {
//        viewController.filteredTracks = filteredTracks
        viewController.reloadTableData(filteredTracksData: filteredTracks)
    }
}
