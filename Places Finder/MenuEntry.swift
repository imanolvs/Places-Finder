//
//  MenuEntry.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 10/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//


struct MenuEntry {
    
    var image : UIImage!
    var title : String!
    
    init(image: UIImage, title: String)
    {
        self.image = image
        self.title = title
    }
}

enum TypeOfPlace : Int16 {
    
    case Restaurant = 0
    case Hotel = 1
    case LeisureSites = 2
}