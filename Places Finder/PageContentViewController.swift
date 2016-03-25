//
//  PageContentViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 15/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

class PageContentViewController : UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    
    var image : UIImage!
    var pageIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
}
