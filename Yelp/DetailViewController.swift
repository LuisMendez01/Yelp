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

class DetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
    @IBOutlet weak var linkTextView: UITextView!
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*********Title In Nav Bar*******/
        setTitleBar()
        
        /*********set Labels and Images*******/
        setLablesAndImages()
        
        // 1. to draw path from current to pin
        mapView.delegate = self
        
        /*********Get any Location*******/
        // set the region to display, this also sets a correct zoom level
        // set starting at this center location
        //let centerLocation = CLLocation(latitude: x, longitude: y)
        //goToLocation(location: centerLocation)
        
        /*************Get current location plus use both location manager funcs below*****************/
        
        //default is San Francisco for simulator
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        /************Make an annotation with help of the annotation funcs below******/
        if let coordinates = business.coordinates {
            let latitude = coordinates["latitude"]!
            let longitude = coordinates["longitude"]!
            
            let centerLocation2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            addAnnotationAtCoordinate(coordinate: centerLocation2D)
            
            // 1. Get destination location
            let destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // 2. Get the placemark
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
            // 3. Get the destination item
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            //Get directions and path from point A to B
            let request = MKDirectionsRequest()
            request.source = MKMapItem.forCurrentLocation()
            request.destination = destinationMapItem//first 3 steps go here
            request.requestsAlternateRoutes = false
            
            let directions = MKDirections(request: request)
            
            directions.calculate(completionHandler: {(response, error) in
                
                if error != nil {
                    print("Error getting directions")
                } else {
                    self.showRoute(response!)
                }
            })
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        let string = "Website"
        let largeAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24)]
        let linkString = NSMutableAttributedString(string: string, attributes: largeAttributes)
        linkString.addAttribute(NSAttributedStringKey.link, value: NSURL(string: business.websiteURL!)!, range: NSMakeRange(0, string.count))
        //linkString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue", size: 22.0)!, range: NSMakeRange(0, string.count))

        linkTextView.attributedText = linkString
        linkTextView.isSelectable = true
        linkTextView.isUserInteractionEnabled = true
        
    }
    
    /************************
     * My CREATED FUNCTIONS *
     ************************/
    func showRoute(_ response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            mapView.add(route.polyline,
                         level: MKOverlayLevel.aboveRoads)
            for step in route.steps {
                print(step.instructions)
            }
        }
    }
    
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
        
        restoImage.alpha = 0.3

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
            let span = MKCoordinateSpanMake(0.01, 0.01)
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

    /*
     * This function allows path from point A to B to show
     */
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.purple
        renderer.lineWidth = 2.0
        return renderer
    }
}

/*
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // 1.
 mapView.delegate = self
 
 // 2.
 let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
 let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
 
 // 3.
 let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
 let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
 
 // 4.
 let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
 let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
 
 // 5.
 let sourceAnnotation = MKPointAnnotation()
 sourceAnnotation.title = "Times Square"
 
 if let location = sourcePlacemark.location {
 sourceAnnotation.coordinate = location.coordinate
 }
 
 
 let destinationAnnotation = MKPointAnnotation()
 destinationAnnotation.title = "Empire State Building"
 
 if let location = destinationPlacemark.location {
 destinationAnnotation.coordinate = location.coordinate
 }
 
 // 6.
 self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
 
 // 7.
 let directionRequest = MKDirectionsRequest()
 directionRequest.source = sourceMapItem
 directionRequest.destination = destinationMapItem
 directionRequest.transportType = .Automobile
 
 // Calculate the direction
 let directions = MKDirections(request: directionRequest)
 
 // 8.
 directions.calculateDirectionsWithCompletionHandler {
 (response, error) -> Void in
 
 guard let response = response else {
 if let error = error {
 print("Error: \(error)")
 }
 
 return
 }
 
 let route = response.routes[0]
 self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
 
 let rect = route.polyline.boundingMapRect
 self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
 }
 }*/
