//
//  ViewController.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 01/03/2023.
//

import UIKit

protocol ViewControllerLogic {
    func searchiTunes()
    func reloadTableData(filteredTracksData: [Track])
    func showNotification(title: String, message: String, actionTitle: String)
}

class ViewController: UITableViewController, ViewControllerLogic {
    
    var tracks = [Track]()
    var filteredTracks = [Track]()
    var interactor: MainInteractor?
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search iTunes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchiTunes))
        
        searchiTunes()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    init(interactor: MainInteractor, presenter: MainPresenter, worker: Worker, coordinator: AppCoordinator) {
        super.init(style: .plain)
        self.interactor = interactor
        self.coordinator = coordinator
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = self
        coordinator.viewController = self
    }
    
    func setup(interactor: MainInteractor, presenter: MainPresenter, worker: Worker, coordinator: AppCoordinator) {
        let viewController = self
        viewController.interactor = interactor
        viewController.coordinator = coordinator
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        coordinator.viewController = viewController
    }
    
    func setup() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let worker = Worker()
        let coordinator = AppCoordinator()
        viewController.interactor = interactor
        viewController.coordinator = coordinator
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        coordinator.viewController = viewController
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Track", for: indexPath)
        let track = filteredTracks[indexPath.row]
        cell.textLabel?.text = track.artistName
        cell.detailTextLabel?.text = track.trackName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = filteredTracks[indexPath.row]
        coordinator?.showAlbumsForArtistFrom(track: track)
    }
    
    @objc func searchiTunes() {
        
        let alertController = UIAlertController(title: "Search", message: "Search iTunes tracks by author", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "OK", style: .default) {
            [weak self] alert in
            guard var searchPhrase = alertController.textFields?[0].text else { return }
            searchPhrase.replace(" ", with: "+")
            
            self?.interactor?.searchiTunes(searchPhrase: searchPhrase)
        }
            
            alertController.addTextField()
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(submitAction)
            
            self.present(alertController, animated: true)
        }
    
    func reloadTableData(filteredTracksData: [Track]) {
        filteredTracks = filteredTracksData
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showNotification(title: String, message: String, actionTitle: String) {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: actionTitle, style: .default))
            self?.present(ac, animated: true)
        }
    }
}
