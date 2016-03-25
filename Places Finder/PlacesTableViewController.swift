//
//  PlacesTableViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 11/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import CoreData

class PlacesTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    var typeOfPlace : TypeOfPlace!
    
//    var numberOfObjects : Int!
    var sharedContext : NSManagedObjectContext { return CoreDataStackManager.sharedInstance().managedObjectContext }
    lazy var fetchedResultsController : NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "isLastSearch == %@", true)
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do { try fetchedResultsController.performFetch() }
        catch { print(error) }

        fetchedResultsController.delegate = self
    }
}

// MARK: Table View Delegate
extension PlacesTableViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceDetailCell") as! PlaceDetailCell
        let place = fetchedResultsController.objectAtIndexPath(indexPath) as! Place
        configureCell(cell, place: place)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PlaceDetailsViewController") as! PlaceDetailsViewController
        let place = fetchedResultsController.objectAtIndexPath(indexPath) as! Place
        
        controller.placeID = place.placeID
        controller.latitude = place.latitude as Double
        controller.longitude = place.longitude as Double
        controller.placeType = self.typeOfPlace
        navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func configureCell(cell: PlaceDetailCell, place: Place) {
        
        var photoImage = UIImage()
        
        cell.activityIndicator.startAnimating()
        cell.nameLabel.text = place.name
        cell.ratingView.rating = place.rating as Double
        
        if place.photoReference == "" || place.photoReference == nil {
            cell.activityIndicator.stopAnimating()
            photoImage = UIImage(named: "noimage")!
        }
            
        else if place.image != nil {
            cell.activityIndicator.stopAnimating()
            photoImage = place.image!
        }
        else {
            
            let task = GoogleClient.sharedInstance().getPhotoFromReference(place.photoReference!) { (data, error) in
                
                guard error == nil else {
                    print(error)
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    place.image = image
                    performUIUpdatesOnMain {
                        cell.cellImageView.image = image
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }
            
            cell.taskToCancelifCellIsReused = task
        }
        
        cell.cellImageView?.image = photoImage
    }
}

// MARK: Fetched Results Controller Delegate
extension PlacesTableViewController {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            break
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            break
        }
    }
}
