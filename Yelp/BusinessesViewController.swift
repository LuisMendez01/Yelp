//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Luis Mendez on 9/21/18.
//  Copyright (c) 2018 Luis Mendez. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate   {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]! = []
    var businessesSearched: [Business]! = []
    
    var isMoreDataLoading = false
    
    /*******************************************
     * UIVIEW CONTROLLER LIFECYCLES FUNCTIONS *
     *******************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.becomeFirstResponder()
        
        searchBar.delegate = self
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        /*********Title Back Button Bar*******/
        //Change the back button of this nav bar to "Search" coz title of
        //this nav bar is "UISearchBar ..." and it's too long to be a back btn
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
        
        fetchData()
        
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "map.png"), for: UIControl.State.normal)
        //add function for button
        button.addTarget(self, action: #selector(BusinessesViewController.goToMap), for: UIControl.Event.touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /************************
     * @OBJC FUNCTIONS *
     ************************/
    @objc func goToMap(_ sender: UIImage) {
        print("segue to MapTrailerController")
        performSegue(withIdentifier: "map", sender: nil)
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func fetchData(){
    
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
    
            self.businesses = businesses
            self.businessesSearched = businesses
    
            // Update flag after 2 seconds when scrolled using only offset because there is a
            // change in the table when it reloads, there is a jumping table and it takes it
            // as a scroll and calls fetchData again back to back, and table bounce is more pronounced
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                // Your code with delay
                self.isMoreDataLoading = false
            }
            
            self.tableView.reloadData()
    
            if let businesses = businesses {
                for business in businesses {
                print(business.name!)
                //print(business.address!)
                //print(business.coordinates!)
                }
            }
    
        })
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"]) { (businesses, error) in
         self.businesses = businesses
         for business in self.businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    /***********************
     * TableView functions *
     ***********************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessViewCell
        
        cell.business = businesses[indexPath.row]
        
        // No color when the user selects cell
        //cell.selectionStyle = .none
        
        // Use a Dark blue color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.7568627451, green: 0.8117647059, blue: 0.8549019608, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        
        //this code changes color of all cells
        cell.contentView.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6745098039, blue: 0.7490196078, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background of the view of the selected cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("In searchbar searching")
        
        //while searching make this true so that it does not fetch unless searchText is empty
        isMoreDataLoading = searchText.isEmpty ? false : true
        
        // If we haven't typed anything into the search bar then do not filter the results
        // movies = searchedMovies otherwise/else filter searchedMovies
        businesses = searchText.isEmpty ? businessesSearched : businessesSearched.filter { ($0).name!.lowercased().contains(searchBar.text!.lowercased()) }//letter anywhere
        
        //movies = searchedMovies.filter { $0 == searchBar.text} //by whole words but who would do that lol
        
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - (tableView.bounds.size.height-25)
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                fetchData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "map" {
            
            // Get in touch with the DetailViewController
            let destinationVC = segue.destination as! MapViewController
            // Pass on the data to the Detail ViewController by setting it's indexPathRow value
            destinationVC.businesses = businesses
            
        } else {
        
            // Get the index path from the cell that was tapped
            let indexPath = tableView.indexPathForSelectedRow
            // Get the Row of the Index Path and set as index
            let index = indexPath?.row
            // Get in touch with the DetailViewController
            let destinationVC = segue.destination as! DetailViewController
            // Pass on the data to the Detail ViewController by setting it's indexPathRow value
            destinationVC.business = businesses[index!]
        }
    }
}
