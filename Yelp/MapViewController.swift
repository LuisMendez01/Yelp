//
//  MapViewController.swift
//  Yelp
//
//  Created by Luis Mendez on 9/25/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var businesses: [Business]! = []
    var locationManager : CLLocationManager!

    @IBOutlet weak var mapView: MKMapView!
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*********Title In Nav Bar*******/
        setTitleBar()

        //self.view.frame.size.width = self.view.frame.size.width - 60
        //self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let titleText = NSAttributedString(string: "Businesses", attributes: strokeTextAttributes)
        
        //adding the titleText
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        //default is San Francisco for simulator
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters//kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        setAllBusinessesPins()
        
        
    }
    
    func setAllBusinessesPins(){
        
        /*******We set all businesse's annotations*****/
        if let businesses = businesses {
            for business in businesses {
                
                /************Make an annotation with help of the annotation funcs below******/
                if let coordinates = business.coordinates {
                    let latitude = coordinates["latitude"]!
                    let longitude = coordinates["longitude"]!
                    
                    let centerLocation2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    addAnnotationAtCoordinate(coordinate: centerLocation2D, name: business.name!)
                    
                    
                    print(business.name!)
                    print(business.coordinates!)
                }
            }
        }
    }
    
    /************************
     * MKMapView FUNCTIONS *
     ************************/
    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
        print("times")
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
    
    /**********get current location of user**************/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        print("In getting permission")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.03, 0.02)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
        
        print("In getting location")
    }

}
