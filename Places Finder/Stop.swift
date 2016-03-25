//
//  Stop.swift
//  Moving in Madrid
//
//  Created by Imanol Viana Sánchez on 10/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class Stop : NSObject, MKAnnotation {
    
    var stopID : String!
    var pointVariableMess : Int!
    var name : String!
    var postalAddress : String!
    var latitude : Double!
    var longitude : Double!
    var listOfLines : [Line]!
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}