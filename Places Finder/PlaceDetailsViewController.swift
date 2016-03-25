//
//  PlaceDetailsViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 13/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import CoreData

private let FLT_MAX = CGFloat(1000)

class PlaceDetailsViewController : UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var placeID : String!
    var photoReferences : [String]!
    var latitude : Double!
    var longitude : Double!
    var placeType : TypeOfPlace!
    var scheduleAvailabe : Bool = false
    var websiteAvailable : Bool = false
    var reviewsAvailable: Bool = false
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var favoriteButton : UIButton!
    @IBOutlet weak var scheduleLabel : UILabel!
    @IBOutlet weak var openNowLabel : UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    var authorName : [String]!
    var textReview : [String]!
    var ratingReview : [Double]!
    var timeInterval : [Double]!
    
    var sharedContext : NSManagedObjectContext { return CoreDataStackManager.sharedInstance().managedObjectContext }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoReferences = [String]()
        authorName = [String]()
        textReview = [String]()
        ratingReview = [Double]()
        timeInterval = [Double]()
        
        if let place = findPlaceFromPlaceID() {
            if place.isFavorite == true { favoriteButton.setImage(UIImage(named: "HearthIconSelected"), forState: .Normal) }
        }
                
        getPlaceDetails()
    }
    
    @IBAction func tapFavoriteButton(sender: UIButton) {
        
        if let place = findPlaceFromPlaceID() {
            
            if place.isFavorite == true {
                
                place.isFavorite = false
                if place.isLastSearch == false { sharedContext.deleteObject(place) }
                favoriteButton.setImage(UIImage(named: "HearthIconDeselected"), forState: .Normal)
            }
            else {
                place.isFavorite = true
                favoriteButton.setImage(UIImage(named: "HearthIconSelected"), forState: .Normal)
            }
        }
        else {
            
            var dict : [String:AnyObject] = [
                Place.Keys.Name : placeNameLabel.text!,
                Place.Keys.PlaceID : placeID,
                Place.Keys.Latitude : latitude,
                Place.Keys.Longitude : longitude,
                Place.Keys.Rating : ratingView.rating]
            
            if photoReferences.count > 0 { dict[Place.Keys.PhotoReference] = photoReferences[0] }
            
            let place = Place(dictionary: dict, placeType: self.placeType, context: sharedContext)
            place.isFavorite = true
            favoriteButton.setImage(UIImage(named: "HearthIconSelected"), forState: .Normal)
        }
        
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let sideFrame = CGFloat(self.view.frame.width / 3 - 2 * 0.5)
        
        flowLayout.minimumInteritemSpacing = 0.5
        flowLayout.minimumLineSpacing = 0.5
        flowLayout.itemSize = CGSize(width: sideFrame, height: sideFrame)
        flowLayout.invalidateLayout()
    }
    
    func getPlaceDetails() {
        
        GoogleClient.sharedInstance().searchPlaceDetail(placeID) { (results, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            
            if let _ = results![GoogleConstants.SearchResponseKeys.Photos] {
                let photos = results![GoogleConstants.SearchResponseKeys.Photos] as! [[String:AnyObject]]
                for photo in photos {
                    let photoReference = photo[GoogleConstants.SearchResponseKeys.PhotoReference] as! String
                    self.photoReferences.append(photoReference)
                    self.getPhotoImage(photoReference)
                }
            }

            performUIUpdatesOnMain {

                self.placeNameLabel.text = results![GoogleConstants.SearchResponseKeys.Name] as? String
                self.addressLabel.text = results![GoogleConstants.DetailsResponseKeys.FormattedAddress] as? String
                self.phoneNumberLabel.text = results![GoogleConstants.DetailsResponseKeys.FormattedPhone] as? String
                
                if let rating = results![GoogleConstants.DetailsResponseKeys.Rating] as? Double { self.ratingView.rating = rating }
                else { self.ratingView.rating = 0 }
                
                if let openingHours = results![GoogleConstants.DetailsResponseKeys.OpeningHours] as? [String:AnyObject] {
                    let openNow = openingHours[GoogleConstants.SearchResponseKeys.OpenNow] as! Bool
                    if openNow == true {
                        self.openNowLabel.text = "Open Now"
                        self.openNowLabel.textColor = UIColor.greenColor()
                    } else {
                        self.openNowLabel.text = "Closed Now"
                        self.openNowLabel.textColor = UIColor.redColor()
                    }
                    
                    if let weekday = openingHours[GoogleConstants.DetailsResponseKeys.WeeakDayText] as? [String] {
                        var string = ""
                        for day in weekday {
                            string = string + day + "\n"
                        }
                        string = String(string.characters.dropLast())
                        self.scheduleLabel.text = string
                    }
                    self.scheduleAvailabe = true
                }
                
                if let website = results![GoogleConstants.DetailsResponseKeys.Website] as? String {
                    self.websiteLabel.text = website
                    self.websiteAvailable = true
                }
                
                if let reviews = results![GoogleConstants.DetailsResponseKeys.Reviews] as? [[String:AnyObject]] {
                    for review in reviews {
                        
                        let authorName = review[GoogleConstants.DetailsResponseKeys.AuthorName] as! String
                        let text = review[GoogleConstants.DetailsResponseKeys.ReviewText] as! String
                        let time = review[GoogleConstants.DetailsResponseKeys.Time] as! Double
                        let rating = review[GoogleConstants.DetailsResponseKeys.Rating] as! Double
                        
                        self.authorName.append(authorName)
                        self.ratingReview.append(rating)
                        self.textReview.append(text)
                        self.timeInterval.append(time)
                    }
                    self.reviewsAvailable = true
                }
                
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
    }
    
    private func getPhotoImage(photoReference: String) {
        
        GoogleClient.sharedInstance().getPhotoFromReference(photoReference) { (data, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            
            if let data = data {
                let image = UIImage(data: data)!
                self.storePhotoImage(photoReference, image: image)
            }
        }
    }
    
    private func findPlaceFromPlaceID() -> Place? {
    
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Place", inManagedObjectContext: sharedContext)
        
        let predicate = NSPredicate(format: "placeID == %@", self.placeID)
        fetchRequest.predicate = predicate
        
        var targetPlace = [AnyObject]()
        do { targetPlace = try sharedContext.executeFetchRequest(fetchRequest) }
        catch { print(error) }
        
        if targetPlace.count == 0 { return nil }
        return targetPlace[0] as? Place    //This is the place we are looking for!
    }
}

// MARK: Fetched Results Controller Delegate Methods
extension PlaceDetailsViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReferences.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoPlaceCell", forIndexPath: indexPath) as! PhotoPlaceCell
        
        configureCell(cell, photoReference: photoReferences[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("RootPageViewController") as! RootPageViewController
        
        controller.photoReferences = photoReferences
        controller.firstIndex = indexPath.item
        
        navigationController?.pushViewController(controller, animated: true)
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
    }
    
    
    private func configureCell(cell: PhotoPlaceCell, photoReference: String) {
        
        cell.imageView.alpha = 0.2
        cell.imageView.backgroundColor = UIColor.grayColor()
        cell.activityIndicator.startAnimating()
        
        if let image = retrievePhotoImage(photoReference) {
            performUIUpdatesOnMain {
                cell.imageView.image = image
                cell.imageView.alpha = 1
                cell.activityIndicator.stopAnimating()
            }
        }
        else {
            
            let task = GoogleClient.sharedInstance().getPhotoFromReference(photoReference) { (data, error) in
                
                guard error == nil else {
                    print(error)
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)!
                    self.storePhotoImage(photoReference, image: image)
                    performUIUpdatesOnMain {
                        cell.imageView.image = image
                        cell.imageView.alpha = 1
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }

            cell.taskToCancelifCellIsReused = task
        }
    }
}

// MARK: Table View Delegate Methods
extension PlaceDetailsViewController {
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            
        case 0:
            if photoReferences.isEmpty { return 0.1 }
        case 2:
            if scheduleAvailabe == false { return 0.1 }
        case 4:
            if reviewsAvailable == false { return 0.1 }
        default:
            break
        }

        return tableView.sectionHeaderHeight
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            
        case 2:
            if scheduleAvailabe == false { return nil }
            else { return "Schedule" }
        case 4:
            if reviewsAvailable == false { return nil }
            else { return "Reviews" }
        default:
            break
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            if photoReferences.isEmpty { return 0 }
            else { return 1 }
        case 1:
            return 1
        case 2:
            if scheduleAvailabe == true { return 1 }
            else { return 0 }
        case 3:
            if websiteAvailable == true { return 3 }
            else { return 2 }
        case 4:
            if reviewsAvailable == false { return 0 }
            else { return 1 }
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddressViewController") as! AddressViewController
                
                controller.latitude = self.latitude
                controller.longitude = self.longitude
                controller.name = ""
                controller.address = ""
                if let address = self.addressLabel.text { controller.address = address }
                if let name = self.placeNameLabel.text { controller.name = name }
                if photoReferences.count > 0 { controller.photoReference = photoReferences[0] }
                else { controller.photoReference = nil }
                
                navigationController?.pushViewController(controller, animated: true)
            }
            else if indexPath.row == 1 {
                if let numberPhone = phoneNumberLabel.text {
                    let phone = "tel://\(numberPhone.removeWhitespace())"
                    let url = NSURL(string: phone)
                    UIApplication.sharedApplication().openURL(url!)
                }
            }
            else {
                
                if let website = websiteLabel.text {
                    let url = NSURL(string: website)
                    UIApplication.sharedApplication().openURL(url!)
                }
            }
        }
        else if indexPath.section == 4 {
            
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ReviewsViewController") as! ReviewsViewController
            
            controller.placeName = self.placeNameLabel.text
            controller.authorName = self.authorName
            controller.ratings = self.ratingReview
            controller.rating = self.ratingView.rating
            controller.timeInterval = self.timeInterval
            controller.reviewText = self.textReview
            
            navigationController?.pushViewController(controller, animated: true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: Extension for the definition of a place image get/set methods
extension PlaceDetailsViewController {
    
    private func retrievePhotoImage(photoReference: String) -> UIImage? {
        
        return ImageCache.sharedInstance().imageWithIdentifier(photoReference)
    }
    
    private func storePhotoImage(photoReference: String, image: UIImage) {
        
        ImageCache.sharedInstance().storeImage(image, withIdentifier: photoReference)
    }
}

// MARK: String extension. Definition of a method for remove all String whitespaces
extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
}