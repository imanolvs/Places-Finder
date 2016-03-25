//
//  RestaurantReview.swift
//  Moving in Madrid
//
//  Created by Imanol Viana Sánchez on 10/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import CoreData

class RestaurantReview : NSManagedObject {
    
    struct Keys {
        static let AuthorName = "address"
        static let AuthorURL = "phoneNumber"
        static let Text = "latitude"
        static let Time = "longitude"
        static let Rating = "rating"
    }
    
    @NSManaged var authorName : String
    @NSManaged var rating : NSNumber
    @NSManaged var time : NSNumber
    @NSManaged var authorURL : String?
    @NSManaged var text : String?
    @NSManaged var restaurant : Restaurant
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("RestaurantReview", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        authorName = dictionary[Keys.AuthorName] as! String
        authorURL = dictionary[Keys.AuthorURL] as? String
        text = dictionary[Keys.Text] as? String
        time = dictionary[Keys.Time] as! Int
        rating = dictionary[Keys.Rating] as! Double
    }
}

