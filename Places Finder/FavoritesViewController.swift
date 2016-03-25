//
//  FavoritesViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 10/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

class FavoritesViewController : UIViewController {
    
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var hotelView: UIView!
    @IBOutlet weak var leisureView: UIView!
    
    override func viewDidLoad() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.view.backgroundColor = UIColor.blueColor()
    }

    @IBAction func showComponent(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.restaurantView.alpha = 1
                self.hotelView.alpha = 0
                self.leisureView.alpha = 0
            })
        }
        else if sender.selectedSegmentIndex == 1 {
            UIView.animateWithDuration(0.5, animations: {
                self.restaurantView.alpha = 0
                self.hotelView.alpha = 1
                self.leisureView.alpha = 0
            })
        }
        else {
            UIView.animateWithDuration(0.5, animations: {
                self.restaurantView.alpha = 0
                self.hotelView.alpha = 0
                self.leisureView.alpha = 1
            })
        }
    }
    
}