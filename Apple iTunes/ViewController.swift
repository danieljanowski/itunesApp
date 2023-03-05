//
//  ViewController.swift
//  Apple iTunes
//
//  Created by Daniel Janowski on 01/03/2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var tracks = [Track]()
    var filteredTracks = [Track]()
    let worker = Worker()
    let interactor = MainInteractor()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search iTunes"
//        presenter would handle bold etc. and call vc show title.
        //vc viewLoad
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchiTunes))
        
        searchiTunes()
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
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        let track = filteredTracks[indexPath.row]
        
        // call to coordinator (track)
        detailViewController.title = track.artistName
        detailViewController.artistId = track.artistId

        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @objc func searchiTunes() {
        
        let alertController = UIAlertController(title: "Search", message: "Search iTunes tracks by author", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "OK", style: .default) {
            [weak self] alert in
            guard var searchPhrase = alertController.textFields?[0].text else { return }
            searchPhrase.replace(" ", with: "+")
            
            self?.interactor.searchiTunes(searchPhrase: searchPhrase)
            
//            self?.worker.searc.hiTunes(searchPhrase: searchPhrase) { (data, response, error) in
//                if let error = error {
//                    self?.showError(with: error)
//                } else if let data = data {
//                    self?.parse(json: data)
//                }
//            }
        }
            
            alertController.addTextField()
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(submitAction)
            
            self.present(alertController, animated: true)
        }
    
//    func parse(json: Data) {
//        let decoder = JSONDecoder()
//        if let jsonTracks = try? decoder.decode(Tracks.self, from: json)
//        {
//            tracks = jsonTracks.results
//            filteredTracks = tracks.filter({$0.artistId != nil && $0.trackName != nil})
//            if filteredTracks.isEmpty { showNoResultsNotification() }
//            DispatchQueue.main.async {
//                [weak self] in
//                self?.tableView.reloadData()
//            }
//        }
//    }
    
    func reloadTableData(filteredTracksData: [Track]) {
        filteredTracks = filteredTracksData
        DispatchQueue.main.async {
            [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showNoResultsNotification() {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Search", message: "No results found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
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
