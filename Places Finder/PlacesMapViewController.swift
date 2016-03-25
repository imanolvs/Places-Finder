//
//  PlacesMapViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 15/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PlacesMapViewController : UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView : MKMapView!
    
    var centerLocation : CLLocationCoordinate2D!
    var typeOfPlace : TypeOfPlace!

    var sharedContext : NSManagedObjectContext { return CoreDataStackManager.sharedInstance().managedObjectContext }
    
    lazy var fetchedResultsController : NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "isLastSearch == %@", true)
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let region = MKCoordinateRegionMake(centerLocation, MKCoordinateSpanMake(0.08, 0.08))
        mapView.setRegion(region, animated: false)
        mapView.showsPointsOfInterest = false
        mapView.showsUserLocation = true
        
        do { try fetchedResultsController.performFetch() }
        catch { print(error) }

        fetchedResultsController.delegate = self
    }
    
    func insertRestaurant(place: Place) {
        
        let annotation = MKPointAnnotation()
        annotation.title = place.name
        annotation.coordinate = place.coordinate
        mapView.addAnnotation(annotation)
    }
    
    func deleteRestaurant(place: Place) {
        
        mapView.removeAnnotation(place)
    }
    
    func updateRestaurant(place: Place) {
        
        let annotation = MKPointAnnotation()
        annotation.title = place.name
        annotation.coordinate = place.coordinate

        mapView.removeAnnotation(place)
        mapView.addAnnotation(annotation)
    }
    
    private func findSelectedPlace(coordinates: CLLocationCoordinate2D) -> Place? {
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Place", inManagedObjectContext: sharedContext)
        
        // Build a predicate using latitude and longitude and link it to the fetchRequest
        let latitude = coordinates.latitude as NSNumber
        let longitude = coordinates.longitude as NSNumber
        let latPredicate = NSPredicate(format: "latitude == %@", latitude)
        let longPredicate = NSPredicate(format: "longitude == %@", longitude)
        let predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [latPredicate, longPredicate])
        fetchRequest.predicate = predicate
        
        // Execute the fetchRequest!
        var targetPlace: AnyObject? = nil
        do {
            targetPlace = try sharedContext.executeFetchRequest(fetchRequest)
        } catch { print(error) }

        return targetPlace![0] as? Place    //This is the place we are looking for!
    }
}

// MARK: MapView Delegate methods
extension PlacesMapViewController {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKUserLocation) { return nil }
        
        let reuseID = "place"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
       
        if pinView == nil {
            
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
            let pinImage = UIImage(named: "LocationCircle")
            let size = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContext(size)
            pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            pinView!.image = resizedImage
            pinView!.opaque = false
            pinView!.alpha = 0.8
            pinView!.draggable = false
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view.annotation!.isKindOfClass(MKUserLocation) { return }
        
        let place = findSelectedPlace(view.annotation!.coordinate)
        let imageView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        imageView.contentMode = .ScaleToFill
        
        if place == nil {
            imageView.image = UIImage(named: "noimage")!
        }
        else if place!.photoReference == "" || place!.photoReference == nil {
            imageView.image = UIImage(named: "noimage")!
        }
        else if place?.image != nil{
            imageView.image = place!.image!
        }
        else { imageView.image = nil }

        view.leftCalloutAccessoryView = imageView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let place = findSelectedPlace(view.annotation!.coordinate) {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PlaceDetailsViewController") as! PlaceDetailsViewController

            controller.placeID = place.placeID
            controller.latitude = place.latitude as Double
            controller.longitude = place.longitude as Double
            controller.placeType = self.typeOfPlace
            navigationController?.pushViewController(controller, animated: true)
        }

        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}

// MARK: Fetched Results Controller Delegate Methods
extension PlacesMapViewController {
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            insertRestaurant(anObject as! Place)
        case .Delete:
            deleteRestaurant(anObject as! Place)
        case .Update:
            updateRestaurant(anObject as! Place)
        default:
            break
        }
    }
}