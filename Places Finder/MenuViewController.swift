//
//  MenuViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 8/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

// MARK: Controller which manages the menu
class MenuViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView : UITableView!
    
    var menuOptions : [MenuEntry] = []
    var typeOfPlace : TypeOfPlace!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillMenuOptions()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath) as! MenuTableViewCell

        cell.cellImageView?.image = menuOptions[indexPath.row].image
        cell.titleLabel?.text = menuOptions[indexPath.row].title
        cell.titleLabel.backgroundColor = view.backgroundColor
        cell.backgroundColor = view.backgroundColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch menuOptions[indexPath.row].title {
        case "Favorites":
            performSegueWithIdentifier("favoriteSegue", sender: self)
        case "Restaurant Browser":
            typeOfPlace = .Restaurant
            performSegueWithIdentifier("searchPlaceSegue", sender: self)
        case "Hotels":
            typeOfPlace = .Hotel
            performSegueWithIdentifier("searchPlaceSegue", sender: self)
        case "Leisure Sites":
            typeOfPlace = .LeisureSites
            performSegueWithIdentifier("searchPlaceSegue", sender: self)
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "searchPlaceSegue" {
            
            let destVC = segue.destinationViewController as! UINavigationController
            let rootVC = destVC.viewControllers.first as! LocationViewController
            rootVC.typeOfPlace = typeOfPlace
        }
    }
    
    func fillMenuOptions() {
        
        var menuEntry = MenuEntry(image: UIImage(named: "favoriteIcon")!, title: "Favorites")
        menuOptions.append(menuEntry)
        menuEntry = MenuEntry(image: UIImage(named: "restaurantIcon")!, title: "Restaurant Browser")
        menuOptions.append(menuEntry)
        menuEntry = MenuEntry(image: UIImage(named: "hotelIcon")!, title: "Hotels")
        menuOptions.append(menuEntry)
        menuEntry = MenuEntry(image: UIImage(named: "leisureIcon")!, title: "Leisure Sites")
        menuOptions.append(menuEntry)
    }
}
