//
//  LocationViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 10/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

class LocationViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var mapView : MKMapView!
    
    var searchController : UISearchController!

    var localSearch : MKLocalSearch?
    var results = MKLocalSearchResponse()
    
    var typeOfPlace : TypeOfPlace!
    let locationManager = CLLocationManager()
    var location : CLLocation = CLLocation()
    
    override func viewDidLoad() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location service enabled")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.frame = CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y, mapView.frame.width, tableView.frame.height)
        setupSearchController()
    }

    private func setupSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search a location"
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.reloadData()
    }
    
    @IBAction func didSelectOtherLocation(sender: UILongPressGestureRecognizer) {
        
        if sender.state != .Began { return }
        
        let point = sender.locationInView(self.mapView)
        let locCoordinate = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView)
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("FilterOptionsViewController") as! FilterOptionsViewController
        
        controller.location = CLLocation(latitude: locCoordinate.latitude, longitude: locCoordinate.longitude)
        controller.typeOfPlace = typeOfPlace
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didSelectMyLocation(sender: UIBarButtonItem) {

        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("FilterOptionsViewController") as! FilterOptionsViewController
        
        controller.location = location
        controller.typeOfPlace = typeOfPlace
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func removeAllPinsButUserLocation() {
        
        mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                mapView.removeAnnotation($0)
            }
        }
    }
    
    private func requestLocalSearchFromString(string: String) {
        
        if let search = localSearch {
            if search.searching {
                search.cancel()
            }
        }
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = string
        localSearch = MKLocalSearch(request: searchRequest)
        
        localSearch!.startWithCompletionHandler() { (response, error) in
            
            guard response != nil else {
                print(error)
                return
            }
            
            self.results = response!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: response!.boundingRegion.center.latitude, longitude: response!.boundingRegion.center.longitude)
            
            let region = MKCoordinateRegionMake(annotation.coordinate, response!.boundingRegion.span)
            
            performUIUpdatesOnMain {
                self.removeAllPinsButUserLocation()
                self.mapView.addAnnotation(annotation)
                self.mapView.centerCoordinate = annotation.coordinate
                self.mapView.setRegion(region, animated: true)
                self.mapView.hidden = false
                self.results = MKLocalSearchResponse()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: Map View Delegate
extension LocationViewController {
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view.annotation!.isKindOfClass(MKUserLocation) { return }
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("FilterOptionsViewController") as! FilterOptionsViewController
        
        controller.location = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
        controller.typeOfPlace = typeOfPlace
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: Location Manager Delegate
extension LocationViewController {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        location = locations[0] as CLLocation
    }
}

// MARK: Table View Delegate
extension LocationViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.mapItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let item = results.mapItems[indexPath.row]
        
        var subtitle = ""
        
        if let locality = item.placemark.locality {
            subtitle = locality
        }
        
        if let country = item.placemark.country {
            if subtitle == "" { subtitle = country }
            else { subtitle = "\(subtitle), \(country)" }
        }
        
        cell.textLabel?.text = item.placemark.name
        cell.detailTextLabel?.text = subtitle
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        searchController.active = false
        
        let item = results.mapItems[indexPath.row]
        var subtitle = ""
        
        if let locality = item.placemark.locality {
            subtitle = locality
        }
        
        if let country = item.placemark.country {
            if subtitle == "" { subtitle = country }
            else { subtitle = "\(subtitle), \(country)" }
        }

        searchController.searchBar.text = "\(item.placemark.name!), \(subtitle)"
        requestLocalSearchFromString(searchController.searchBar.text!)
    }
}

// MARK: Search Bar Delegate
extension LocationViewController {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        requestLocalSearchFromString(searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        mapView.hidden = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let search = localSearch {
            if search.searching {
                search.cancel()
            }
        }
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchText
        localSearch = MKLocalSearch(request: searchRequest)

        localSearch!.startWithCompletionHandler() { (response, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            
            guard let results = response else {
                print("No results")
                return
            }
            
            self.results = results
            performUIUpdatesOnMain { self.tableView.reloadData() }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        mapView.hidden = false
        results = MKLocalSearchResponse()
        tableView.reloadData()
    }
}
