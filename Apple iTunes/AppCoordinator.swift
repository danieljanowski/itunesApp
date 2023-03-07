//
//  Coordinator.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 05/03/2023.
//

import Foundation
import UIKit

protocol AppCoordinatorLogic {
    func showAlbumsForArtistFrom(track: Track)
}

class AppCoordinator: AppCoordinatorLogic {
    var viewController : ViewController?
    
    func showAlbumsForArtistFrom(track: Track) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        
        detailViewController.title = track.artistName
        detailViewController.artistId = track.artistId
        
//        viewController?.show(detailViewController, sender: nil)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
