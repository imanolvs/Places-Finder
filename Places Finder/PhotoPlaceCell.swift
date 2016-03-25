//
//  PhotoPlaceCell.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 13/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

class PhotoPlaceCell : UICollectionViewCell{
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}

