//
//  ArtistFeedViewController.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/26/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import UIKit

class ArtistFeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var data: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        data = User.getArtists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = User.getArtists()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if let latestRelease: Track = artist.latestRelease() {
            cell.albumNameLabel.text = latestRelease.collectionName
            cell.artistNameLabel.text = latestRelease.artistName
            
            let formatter = ISO8601DateFormatter()
            cell.dateLabel.text = formatter.string(from: latestRelease.releaseDate!)
            
            if let artworkUrl = latestRelease.artworkUrl100 {
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
        }

        
        return cell
    }
}
