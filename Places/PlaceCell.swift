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
    
    var imageFetchTask:NSURLSessionTask?
    
    
    func updateUI() {
        placeNameLabel.text = place?.name
        
        if let currentPlace = place {
            
        imageFetchTask = ServerManager.sharedManager.getVenueIcon(currentPlace.id, completion: { [weak self] result in
            
            if let wself = self, case .Success(let urlConstructor as IconURLConstructor) = result {
                if let url = urlConstructor.assembleSmalURL() {
                    wself.placeImageView.af_setImageWithURL(url, placeholderImage: wself.placeholder)
                }
            }
        })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        place = nil
        imageFetchTask?.cancel()
        placeNameLabel.text = nil
        placeImageView.image = self.placeholder
    }
}
