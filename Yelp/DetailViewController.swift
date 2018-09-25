//
//  DetailViewController.swift
//  Yelp
//
//  Created by Luis Mendez on 9/24/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var restoName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var stars: UIImageView!
    @IBOutlet weak var restoImage: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    
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
        
        /*********Get any Location*******/
        // set the region to display, this also sets a correct zoom level
        // set starting at this center location
        //let centerLocation = CLLocation(latitude: x, longitude: y)
        //goToLocation(location: centerLocation)
        
        /*************Get current location plus use both location manager funcs below*****************/
        
        //default is San Francisco for simulator
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        /************Make an annotation with help of the annotation funcs below******/
        if let coordinates = business.coordinates {
            let latitude = coordinates["latitude"]!
            let longitude = coordinates["longitude"]!
            
            let centerLocation2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            addAnnotationAtCoordinate(coordinate: centerLocation2D)
        }
        
      
    }
    
    /************************
     * My CREATED FUNCTIONS *
     ************************/
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
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
        
        categories.sizeToFit() 
        
    //"dfadfadfadfadfdfdfdfdfdfdfadfdfdffafafaffddfdafadfdfdfdfdfdfdfdfdfdfdafdafadfdfdfdfdfdfdfdfdfdfdsfdfdfdfddfadkllkhlkhlkhlkhlklhklkhlklklklklhkklklklklklklklklkjlklklklklklklklklklklklklklkllknnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn89"
        
        //having already set width of label as constraint
        //we can use MaxLayoutWidth to make text wrap around
        //having set lines to 0 and line break to word wrap
        //if and only if trailing constraint was not set in cases
        //such there is no a label next to it
        categories.preferredMaxLayoutWidth = categories.frame.size.width
        
        restoImage.alpha = 0.4

    }
    
    /***********************
     * MKMapView FUNCTIONS *
     ***********************/
    
    /**********get current location of user**************/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        print("In getting permission")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
        
        print("In getting location")
    }
    
    /**********Add annotations**************/
    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = business.name
        mapView.addAnnotation(annotation)
    }
    
    // add an annotation with an address: String
    func addAnnotationAtAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}
