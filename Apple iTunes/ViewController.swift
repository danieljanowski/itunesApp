//
//  ViewController.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 01/03/2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var tracks = [Track]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search iTunes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchiTunes))
        
        searchiTunes()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Track", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.artistName
        cell.detailTextLabel?.text = track.trackName
        
        return cell
    }
    
    @objc func searchiTunes() {
        
        let urlString = "https://itunes.apple.com/search?term="
        
        let alertController = UIAlertController(title: "Search", message: "Search iTunes tracks by author", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "OK", style: .default) {
            [weak self] alert in
            guard var searchPhrase = alertController.textFields?[0].text else { return }
            searchPhrase.replace(" ", with: "+")
            
            let searchUrlWithQuery = urlString + searchPhrase.lowercased()
            
            DispatchQueue.global(qos: .userInitiated).async {
                let urlComponents = URLComponents(string: searchUrlWithQuery)
                let request = URLRequest(url: (urlComponents?.url)!)
                let task = URLSession.shared.dataTask(with: request) {
                    (data, response, error) -> Void in
                        if error != nil {
                            self?.showError(with: error)
                        }

                    guard let dataToParse = data else { return }
                    self?.parse(json: dataToParse)
                }
                task.resume()
            }
        }

        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(submitAction)
        
        present(alertController, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonTracks = try? decoder.decode(Tracks.self, from: json)
        {
            tracks = jsonTracks.results
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
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
}
