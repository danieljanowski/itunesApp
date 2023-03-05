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
    
    var albums = [Album]()
    var artistId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadAlbums()
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
        loadAlbumArt(urlString: urlString)
        //interactor (user input) fetches API (worker)->presenter (filters na converts to model and tells viewc to present)->viewcontroller presnts and refreshes tableview
        //3 protocols
    }
    
    func loadAlbums() {
        guard let artistIdUnwrapped = artistId else { return }
        let urlString = "https://itunes.apple.com/lookup?id=\(artistIdUnwrapped)&entity=album"
        
        APIClient.call(url: urlString) { (data, response, error) in
                    if error != nil {
                        self.showError(with: error)
                    }
                guard let dataToParse = data else { return }
                self.parse(json: dataToParse)
                if !self.albums.isEmpty {
                    guard let unwrappedUrl = self.albums[0].artworkUrl100 else { return } //presenter
                    self.loadAlbumArt(urlString: unwrappedUrl) }
            }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonTracks = try? decoder.decode(Albums.self, from: json)
        {
            albums = jsonTracks.results.filter({$0.collectionName != nil && $0.artworkUrl100 != nil})
            if albums.isEmpty { showNoResultsNotification() }
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func showNoResultsNotification() {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Search", message: "No albums found for this artist", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    func loadAlbumArt(urlString: String){
        APIClient.call(url: urlString) { (data, response, error) in
                if error != nil {
                    self.showError(with: error)
                }

            guard let dataToParse = data else { return }
            DispatchQueue.main.async {
                [weak self] in
                self?.imageView.image = UIImage(data: dataToParse)
            }
        }
    }
    
    //private method for API call
    //3 public methods for call and parse
    
    //interactor call API
    //coordinator would have showError. - also Router
    
    
    func showError(with error : Error?) {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. \(error?.localizedDescription ?? "")", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
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
