//
//  AmazingFindCell.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/28/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit

class AmazingFindCell: UICollectionViewCell {
    
    static let reuseIdentifier = "AmazingFindCell"
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    private let placeholder: UIImage = {
        return UIImage(named: "place_placeholder")!
    }()
    
    var place: AmazingFind! {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
        placeTitleLabel.text = place.placeTitle
        locationLabel.text = place.placeLocationDescription
        guard let imgUrlString = place?.placeImageUrl else {return}
        guard let imgUrl = NSURL(string:imgUrlString) else {return}
        placeImageView.af_setImageWithURL(imgUrl, placeholderImage: placeholder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeTitleLabel.text = nil
        locationLabel.text = nil
        placeImageView.image = self.placeholder
    }
}
