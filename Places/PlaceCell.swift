//
//  PlaceCell.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit
import AlamofireImage


class PlaceCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PlaceCell"
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    private let placeholder: UIImage = {
       return UIImage(named: "place_placeholder")!
    }()
    
    var place: Place! {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
        placeNameLabel.text = place.name
        
        place.placeIconURL?.palaceIconURL { [weak self] url in
            if let u = url, wself = self {
                wself.placeImageView.af_setImageWithURL(u, placeholderImage: wself.placeholder)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeNameLabel.text = nil
        placeImageView.image = self.placeholder
    }
}
