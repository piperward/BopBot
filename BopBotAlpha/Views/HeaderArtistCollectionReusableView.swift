//
//  HeaderArtistCollectionReusableView.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/25/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import UIKit

protocol HeaderArtistCollectionReusableViewDelegate {
    func updateFollowButton()
}

class HeaderArtistCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var followButton: UIButton!
    
    var delegate: HeaderArtistCollectionReusableViewDelegate?
    
    var artist: Artist? {
        didSet {
            updateStateFollowButton()
        }
    }
    
    func updateStateFollowButton() {
        if User.isFollowing(artist!) {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func configureFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followButton.setTitle("Follow", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("Following", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
        
    @objc func followAction() {
//        if user!.isFollowing! == false {
//            Api.Follow.followAction(withUser: user!.id!)
//            configureUnFollowButton()
//            user!.isFollowing! = true
//            delegate?.updateFollowButton(forUser: user!)
//        }
        
        if !User.isFollowing((artist?.artistName)!) {
            configureUnFollowButton()
            User.follow(artist!)
            delegate?.updateFollowButton()
        }
    }
    
    @objc func unFollowAction() {
//        if user!.isFollowing! == true {
//            Api.Follow.unFollowAction(withUser: user!.id!)
//            configureFollowButton()
//            user!.isFollowing! = false
//            delegate?.updateFollowButton(forUser: user!)
//        }

        if User.isFollowing((artist?.artistName)!) {
            configureFollowButton()
            User.unfollow(artist!)
            delegate?.updateFollowButton()
        }
    }
    
}
