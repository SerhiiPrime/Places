//
//  PlaceDetailsViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/29/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit
import AlamofireImage

class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    var place: PlaceDetails!
    
    private let placeholder: UIImage = {
        return UIImage(named: "place_placeholder")!
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeNameLabel.text = place.name
        placeAddress.text = place.address
        phoneLabel.text = place.phone
        hoursLabel.text = place.hoursStatus
        ratingLabel.text = place.rating?.description
        reasonLabel.text = place.reasonSummary
        reasonLabel.sizeToFit()
        
        if let url = place.iconConstructor?.assembleBigURL() {
            placeImageView.af_setImageWithURL(url, placeholderImage: placeholder)
        }
    }
    
    @IBAction func viewOnMapAction(sender: AnyObject) {
        performSegueWithIdentifier(GlobalConstants.SegueIdentifiers.mapViewController, sender: place)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == GlobalConstants.SegueIdentifiers.mapViewController {
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.venue = sender as? PlaceDetails
        }
    }
}
