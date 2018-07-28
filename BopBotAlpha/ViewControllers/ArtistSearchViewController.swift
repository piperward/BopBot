//
//  FirstViewController.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/7/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import UIKit

class ArtistSearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var artistNames: [String] = []
    var tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ArtistSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        self.artistNames.removeAll()
        self.tracks.removeAll()
        self.tableView.reloadData()
        if let searchText = searchBar.text {
            let search = searchText.lowercased().replacingOccurrences(of: " ", with: "+")
            
            guard let searchUrl = URL(string: "https://itunes.apple.com/search?term=" + search) else { return }
            
            URLSession.shared.dataTask(with: searchUrl) { (data, response, error)
                in
                
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let searchData = try decoder.decode(Result.self, from: data)
                    
                    DispatchQueue.main.sync {
                        for track in searchData.results {
                            self.tracks.append(track)
                            if let artist = track.artistName {
                                if !self.artistNames.contains(artist) {
                                    self.artistNames.append(artist)
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                } catch let err {
                    print("Err", err)
                }
                }.resume()
        }
    }
}

extension ArtistSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
        let result = artistNames[indexPath.row]
        cell.textLabel?.text = result
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToDetail", let destination = segue.destination as? ArtistDetailViewController {
            let currentTableViewCell = sender as! SearchTableViewCell
            destination.artistName = currentTableViewCell.title.text!
            destination.artistNames = self.artistNames
            destination.tracks = self.tracks
        }
    }
}
