//
//  DetailViewController.swift
//  Yelp
//
//  Created by Luis Mendez on 9/24/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var restoName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var stars: UIImageView!
    @IBOutlet weak var restoImage: UIImageView!
    
    var business: Business! = nil

    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*********Title In Nav Bar*******/
        setTitleBar()
        
        /*********set Labels and Images*******/
        setLablesAndImages()
      
    }
    
    /************************
     * My CREATED FUNCTIONS *
     ************************/
    func setTitleBar(){
    
        let titleLabel = UILabel()//for the title of the page
        
        //set some attributes for the title of this controller
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor : UIColor.white,
            .foregroundColor : UIColor(cgColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),  /*UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8)*/
            .strokeWidth : -1,
            .font : UIFont.boldSystemFont(ofSize: 17)
        ]
        
        //titleLabel.frame = CGRect(x:0, y:0, width:50, height:60)
        //titleLabel.center = CGPoint(x: 380/2, y: 245)
        //titleLabel.numberOfLines = 0
        //titleLabel.lineBreakMode = .byWordWrapping
        //titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        
        //set the name and put in the attributes for it
        let titleText = NSAttributedString(string: business.name!, attributes: strokeTextAttributes)
        
        //adding the titleText
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    func setLablesAndImages() {
        
        restoName.text = business.name
        distance.text = business.distance
        reviews.text = "\(business.reviewCount!) Reviews"
        address.text = business.address
        categories.text = business.categories
        stars.image =  business.ratingImage
        restoImage.setImageWith(business.imageURL!)
        
    //"dfadfadfadfadfdfdfdfdfdfdfadfdfdffafafaffddfdafadfdfdfdfdfdfdfdfdfdfdafdafadfdfdfdfdfdfdfdfdfdfdsfdfdfdfddfadkllkhlkhlkhlkhlklhklkhlklklklklhkklklklklklklklklkjlklklklklklklklklklklklklklkllknnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn89"
        
        //having already set width of label as constraint
        //we can use MaxLayoutWidth to make text wrap around
        //having set lines to 0 and line break to word wrap
        //if and only if trailing constraint was not set in cases
        //such there is no a label next to it
        categories.preferredMaxLayoutWidth = categories.frame.size.width
        
        restoImage.alpha = 0.3

    }
}
