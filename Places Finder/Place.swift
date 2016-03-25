//
//  Place.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 10/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class Place : NSManagedObject, MKAnnotation {
    
    struct Keys {
        static let Name = "name"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let PlaceID = "place_id"
        static let Rating = "rating"
        static let Photos = "photos"
        static let PhotoReference = "photo_reference"
        static let PlaceType = "place_type"
    }
    
    @NSManaged var name : String
    @NSManaged var latitude : NSNumber
    @NSManaged var longitude : NSNumber
    @NSManaged var placeID : String
    @NSManaged var rating : NSNumber
    @NSManaged var photoReference : String?
    @NSManaged var typeOfPlace : Int16
    @NSManaged var isFavorite : Bool
    @NSManaged var isLastSearch : Bool
    
    var image : UIImage?
    {
        get { return ImageCache.sharedInstance().imageWithIdentifier(photoReference) }
        set { ImageCache.sharedInstance().storeImage(newValue, withIdentifier: photoReference!) }
    }
    
    var typeEnum : TypeOfPlace {
        get { return TypeOfPlace(rawValue: self.typeOfPlace) ?? .Restaurant }
        set { self.typeOfPlace = newValue.rawValue }
    }
    
    var coordinate: CLLocationCoordinate2D {
        let lat = latitude as Double
        let lng = longitude as Double
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], placeType: TypeOfPlace, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Place", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        latitude = dictionary[Keys.Latitude] as! Double
        longitude = dictionary[Keys.Longitude] as! Double
        name = dictionary[Keys.Name] as! String
        placeID = dictionary[Keys.PlaceID] as! String
        rating = dictionary[Keys.Rating] as! Double
        typeOfPlace = placeType.rawValue
        
        photoReference = ""
        if let _ = dictionary[Keys.Photos] {
            let photos = dictionary[Keys.Photos] as! [[String:AnyObject]]
            photoReference = photos[0][Keys.PhotoReference] as? String
        }
        if let _ = dictionary[Keys.PhotoReference] {
            photoReference = dictionary[Keys.PhotoReference] as? String
        }
        
        isFavorite = false
        isLastSearch = true
    }
}