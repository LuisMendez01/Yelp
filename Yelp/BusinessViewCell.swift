//
//  BusinessCell.swift
//  Yelp
//
//  Created by Luis Mendez on 9/22/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class BusinessViewCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            thumbImageView.setImageWith(business.imageURL!)
            ratingImageView.image = business.ratingImage
            restaurantLabel.text = business.name
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            distanceLabel.text = business.distance
            categoriesLabel.text = business.categories
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.clipsToBounds = true
        thumbImageView.layer.cornerRadius = 5
        
        distanceLabel.preferredMaxLayoutWidth = distanceLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
