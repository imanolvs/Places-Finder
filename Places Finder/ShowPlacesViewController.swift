//
//  ShowRestaurantsViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 13/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ShowPlacesViewController : UIViewController {
    
    @IBOutlet var listContainerView: UIView!
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet weak var swapListMapButton : UIBarButtonItem!
    
    var openNow : Bool!
    var radius : Int!
    var price : Int?
    var leisureType : String?
    var location : CLLocationCoordinate2D!
    var pageToken : String = ""
    var didFirstRequest : Bool = false
    var typeOfPlace : TypeOfPlace!

    var sharedContext : NSManagedObjectContext { return CoreDataStackManager.sharedInstance().managedObjectContext }
    
    lazy var fetchedResultsController : NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        listContainerView.alpha = 1
        mapContainerView.alpha = 0
        
        do { try fetchedResultsController.performFetch() }
        catch { print(error) }
        
        deleteLastSearches()
        willRequestRestaurants()
    }
        
    @IBAction func changeContainerView(sender: UIBarButtonItem) {
        
        if sender.title == "Show Map" {
            sender.title = "Show List"
            listContainerView.alpha = 0
            mapContainerView.alpha = 1
        }
        else {
            sender.title = "Show Map"
            listContainerView.alpha = 1
            mapContainerView.alpha = 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "mapPlaceSegue" {
            
            let mapVC = segue.destinationViewController as! PlacesMapViewController
            mapVC.centerLocation = location
            mapVC.typeOfPlace = typeOfPlace
        } else if segue.identifier == "tablePlaceSegue" {
            let tableVC = segue.destinationViewController as! PlacesTableViewController
            tableVC.typeOfPlace = typeOfPlace
        }
    }
    
    func willRequestRestaurants() {
        
        let parameters = buildSearchRequestParameters()
        GoogleClient.sharedInstance().searchNearbyRestaurants(parameters) { (nextPageToken, results, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            
            if let token = nextPageToken { self.pageToken = token }
            else { self.pageToken = "" }
            
            self.didFirstRequest = true
            
            for r in results! {
                var dict = [String:AnyObject]()
                dict[Place.Keys.Name] = r[GoogleConstants.SearchResponseKeys.Name]
                dict[Place.Keys.PlaceID] = r[GoogleConstants.SearchResponseKeys.PlaceID]
                dict[Place.Keys.Photos] = r[GoogleConstants.SearchResponseKeys.Photos]
                
                let geometry = r[GoogleConstants.SearchResponseKeys.Geometry]
                let location = geometry![GoogleConstants.SearchResponseKeys.Location]!
                dict[Place.Keys.Latitude] = location![GoogleConstants.SearchResponseKeys.Latitude]
                dict[Place.Keys.Longitude] = location![GoogleConstants.SearchResponseKeys.Longitude]
                
                if let rating = r[GoogleConstants.SearchResponseKeys.Rating] { dict[Place.Keys.Rating] = rating }
                else { dict[Place.Keys.Rating] = 0 }
                
                let place = Place(dictionary: dict, placeType: self.typeOfPlace, context: self.sharedContext)
                self.storePhotoImage(place)
            }
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    
    func storePhotoImage(place: Place) {
        
        if place.photoReference == nil { return }
        
        GoogleClient.sharedInstance().getPhotoFromReference(place.photoReference!) { (data, error) in
                
            guard error == nil else {
                print(error)
                return
            }
                
            let image = UIImage(data: data!)
            place.image = image
        }
    }
}

extension ShowPlacesViewController {
    
    private func buildSearchRequestParameters() -> [String:AnyObject] {
        
        var parameters = [String:AnyObject]()
        
        parameters[GoogleConstants.ParameterKeys.Location] = "\(location.latitude),\(location.longitude)"
        parameters[GoogleConstants.ParameterKeys.Radius] = radius
        parameters[GoogleConstants.ParameterKeys.PageToken] = pageToken
        parameters[GoogleConstants.ParameterKeys.Language] = GoogleClient.sharedInstance().getValidLanguage()
        if openNow == true {
            parameters[GoogleConstants.ParameterKeys.OpenNow] = "true"
        }
        if price != nil {
            parameters[GoogleConstants.ParameterKeys.MaxPrice] = price
        }
        if typeOfPlace == TypeOfPlace.Restaurant {
            parameters[GoogleConstants.ParameterKeys.Type] = GoogleConstants.SearchTypesValues.Restaurant
        }
        else if typeOfPlace == TypeOfPlace.Hotel {
            parameters[GoogleConstants.ParameterKeys.Type] = GoogleConstants.SearchTypesValues.Lodging
        }
        else {
            parameters[GoogleConstants.ParameterKeys.Type] = leisureType
        }
        parameters[GoogleConstants.ParameterKeys.APIKey] = GoogleConstants.GooglePlaces.APIKey
        
        return parameters
    }
    
    private func deleteLastSearches() {
        
        for object in fetchedResultsController.fetchedObjects! {
            let obj = object as! Place
            if obj.isFavorite == false {
                sharedContext.deleteObject(obj)
                CoreDataStackManager.sharedInstance().saveContext()
            }
            else { obj.isLastSearch = false }
        }
    }
}