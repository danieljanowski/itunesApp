//
//  DetailViewController.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 01/03/2023.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    let apiClient = APIClient()
    var interactor: DetailIntercator?
    
    var albums = [Album]()
    var artistId: Int?
    
    init?(coder: NSCoder, interactor: DetailIntercator, presenter: DetailPresenter, worker: Worker) {
        super.init(coder: coder)
        self.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        setup()
    }
    
    //TODO: replace setup with dependency injection
//    func setup() {
//        let viewController = self
//        let interactor = DetailIntercator()
//        let presenter = DetailPresenter()
//        let worker = Worker()
////        let coordinator = AppCoordinator()
//        viewController.interactor = interactor
////        viewController.coordinator = coordinator
//        interactor.presenter = presenter
//        interactor.worker = worker
//        presenter.viewController = viewController
////        coordinator.viewController = viewController
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let unwrappedArtistId = artistId else { return }
        interactor?.loadAlbums(artistId: unwrappedArtistId)
//        loadAlbums()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Album", for: indexPath) as UITableViewCell
        
        let album = albums[indexPath.row]
        cell.textLabel?.text = album.artistName
        cell.detailTextLabel?.text = album.collectionName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlString = albums[indexPath.row].artworkUrl100 else { return }
        interactor?.loadAlbumArt(urlString: urlString)
        
        //interactor (user input) fetches API (worker)->presenter (filters na converts to model and tells viewc to present)->viewcontroller presnts and refreshes tableview
        //3 protocols
    }
    
    func showImageData(data: Data){
        DispatchQueue.main.async {
            [weak self] in
            self?.imageView.image = UIImage(data: data)
        }
    }
    
    func showError(with error : Error?) {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. \(error?.localizedDescription ?? "")", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
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
    
    func reloadTableData(filteredAlbumsData: [Album]) {
        albums = filteredAlbumsData
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
