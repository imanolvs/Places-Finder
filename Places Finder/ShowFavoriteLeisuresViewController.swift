//
//  ShowFavoriteLeisuresViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 10/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import CoreData

import UIKit
import CoreData

class ShowFavoriteLeisuresViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    
    var sharedContext : NSManagedObjectContext { return CoreDataStackManager.sharedInstance().managedObjectContext }
    
    lazy var fetchedResultsController : NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Place")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        let favPredicate = NSPredicate(format: "isFavorite == %@", true)
        let placeTypePredicate = NSPredicate(format: "typeOfPlace == %d", TypeOfPlace.LeisureSites.rawValue)
        let predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [favPredicate, placeTypePredicate])
        fetchRequest.predicate = predicate
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do { try fetchedResultsController.performFetch() }
        catch { print(error) }
        
        if fetchedResultsController.fetchedObjects?.count == 0 { tableView.hidden = true }
        else { tableView.hidden = false }
        
        fetchedResultsController.delegate = self
    }
}

// MARK: Table View Delegate Methods
extension ShowFavoriteLeisuresViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let leisure = fetchedResultsController.objectAtIndexPath(indexPath) as! Place
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceDetailCell") as! PlaceDetailCell
        
        configureCell(cell, leisure: leisure)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PlaceDetailsViewController") as! PlaceDetailsViewController
        let leisure = fetchedResultsController.objectAtIndexPath(indexPath) as! Place
        
        controller.placeID = leisure.placeID
        controller.latitude = leisure.latitude as Double
        controller.longitude = leisure.longitude as Double
        controller.placeType = leisure.typeEnum
        navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func configureCell(cell: PlaceDetailCell, leisure: Place) {
        
        cell.activityIndicator.startAnimating()
        cell.cellImageView?.alpha = 0.2
        cell.nameLabel.text = leisure.name
        cell.ratingView.rating = leisure.rating as Double
        
        if leisure.photoReference == "" || leisure.photoReference == nil {
            performUIUpdatesOnMain {
                cell.activityIndicator.stopAnimating()
                cell.cellImageView?.alpha = 1
                cell.cellImageView?.image = UIImage(named: "noimage")
            }
        }
        else if leisure.image != nil {
            performUIUpdatesOnMain {
                cell.activityIndicator.stopAnimating()
                cell.cellImageView?.alpha = 1
                cell.cellImageView?.image = leisure.image
            }
        }
        else {
            
            let task = GoogleClient.sharedInstance().getPhotoFromReference(leisure.photoReference!) { (data, error) in
                
                guard error == nil else {
                    print(error)
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    leisure.image = image
                    performUIUpdatesOnMain {
                        cell.cellImageView.image = image
                        cell.activityIndicator.stopAnimating()
                        cell.cellImageView?.alpha = 1
                    }
                }
            }
            
            cell.taskToCancelifCellIsReused = task
        }
    }
}

// MARK: Fetched Results Controller Delegate Methods
extension ShowFavoriteLeisuresViewController {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! PlaceDetailCell
            let leisure = controller.objectAtIndexPath(indexPath!) as! Place
            self.configureCell(cell, leisure: leisure)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
}