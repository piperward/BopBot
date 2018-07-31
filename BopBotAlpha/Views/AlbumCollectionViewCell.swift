//
//  AlbumCollectionViewCell.swift
//  BopBotAlpha
//
//  Created by Piper Ward on 7/8/18.
//  Copyright © 2018 Piper Ward. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionArtwork: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.collectionNameLabel.textColor = UIColor.gray
                self.artistNameLabel.textColor = UIColor.gray
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.collectionNameLabel.textColor = UIColor.white
                self.artistNameLabel.textColor = UIColor.white
            }
        }
    }
}
