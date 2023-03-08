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
        
        let interactor = DetailIntercator()
        let presenter = DetailPresenter()
        let worker = Worker()

        let detailViewController = storyboard.instantiateViewController(identifier: "Detail", creator: { coder in
            return DetailViewController(coder: coder, interactor: interactor, presenter: presenter, worker: worker)}) as DetailViewController
        
//        interactor.presenter = presenter
//        interactor.worker = worker
//        detailViewController.interactor = interactor
//        presenter.viewController = detailViewController

        detailViewController.title = track.artistName
        detailViewController.artistId = track.artistId

        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
//        }
        
//        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
//
//        detailViewController.title = track.artistName
//        detailViewController.artistId = track.artistId
//
////        viewController?.show(detailViewController, sender: nil)
//        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
