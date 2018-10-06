//
//  ArtistFeedViewController.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/26/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import UIKit
import Firebase

class ArtistFeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var data: [CodableArtist] = []
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Feed"
        tableView.dataSource = self
        tableView.delegate = self
        
        updateAlbums(self.title)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(updateAlbums(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func updateAlbums(_: Any) {
        self.data.removeAll()
        Api.observeFollowingArtists() { (artists) in
            self.updateAlbums(artists: artists)
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ArtistFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        let artist = data[indexPath.row]
        //Set artist name label
        cell.artistNameLabel.text = artist.artistName
        
        //Set album name label
        if let albumName = artist.albumName {
            cell.albumNameLabel.text = albumName
        }
        
        //Fetch and load album artwork via url
        if let artworkUrl = artist.artworkUrl100 {
            if let imageUrl = URL(string: artworkUrl) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.artworkImageView.image = image
                        }
                    }
                    }.resume()
            }
        }
        
        //Format release date and set release date label
        if let releaseDate = artist.releaseDate {
            //DateFormatter used to properly display release date
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"
            if releaseDate != nil {
                if let date = dateFormatterGet.date(from: releaseDate){
                    cell.dateLabel.text = dateFormatterPrint.string(from: date)
                }
                else {
                    print("There was an error decoding the string")
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let current = data[indexPath.row]
            self.data.remove(at: indexPath.row)
            User.unfollow(Artist(artistName: current.artistName))
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ArtistFeedViewController {
    fileprivate func updateAlbums(artists: [CodableArtist]) {
        for artist in artists {
            data.append(artist)
            self.tableView.reloadData()
        }
    }
}

