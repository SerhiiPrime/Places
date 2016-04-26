//
//  PlaceCell.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit

class PlaceCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PlaceCell"
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var place: Place! {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
        placeNameLabel.text = place.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeNameLabel.text = nil
        placeImageView.image = nil
    }
}
