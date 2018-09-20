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
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.reloadData()
        tableView.keyboardDismissMode = .onDrag
        
        self.title = "Search"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ArtistSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        self.artistNames.removeAll()
        self.albums.removeAll()
        self.tableView.reloadData()
        if let searchText = searchBar.text {
            let search = searchText.lowercased().replacingOccurrences(of: " ", with: "+")
            
            guard let searchUrl = URL(string: "https://itunes.apple.com/search?term=" + search + "&entity=album") else { return }
            
            URLSession.shared.dataTask(with: searchUrl) { (data, response, error)
                in
                
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let searchData = try decoder.decode(Result.self, from: data)
                    
                    DispatchQueue.main.sync {
                        for album in searchData.results {
                            self.albums.append(album)
                            if !self.artistNames.contains(album.artistName!) {
                                self.artistNames.append(album.artistName!)
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
            let name = currentTableViewCell.title.text!
            destination.artistName = name
            destination.artistNames = self.artistNames
            destination.albums = self.albums.filter{$0.artistName == name}
        }
    }
}
