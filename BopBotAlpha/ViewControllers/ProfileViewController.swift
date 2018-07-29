//
//  ProfileViewController.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/28/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var data: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.clear.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        editProfileButton.backgroundColor = .clear
        editProfileButton.layer.cornerRadius = 5
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = UIColor.gray.cgColor
        
        editProfileButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        data = User.getArtists()
        tableView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "My Profile"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = User.getArtists()
        tableView.reloadData()
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath)
        let artist = data[indexPath.row]
        
        cell.textLabel?.text = artist.artistName
        
        return cell
    }
}
