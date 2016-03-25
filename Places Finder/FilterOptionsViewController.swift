//
//  FilterOptionsViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 12/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import CoreLocation

class FilterOptionsViewController : UITableViewController {

    struct LeisureKeys {
        
        static let AmusementPark = "Amusement Park"
        static let ArtGallery = "Art Gallery"
        static let ShoppingMall = "Shopping Mall"
        static let BowlingAlley = "Bowling Alley"
        static let MovieTheater = "Movie Theater"
        static let NightClub = "Night Club"
        static let Casino = "Casino"
        static let Museum = "Museum"
        static let Church = "Church"
        static let Mosque = "Mosque"
        static let Synagogue = "Synagogue"
        static let Stadium = "Stadium"
        static let Gym = "Gym"
        static let Zoo = "Zoo"
    }
    
    @IBOutlet weak var radiusLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var openNow : UISwitch!
    @IBOutlet weak var leisureLabel : UILabel!
    
    var location : CLLocation = CLLocation()
    var typeOfPlace : TypeOfPlace!
    var radius : Int! = 500
    var leisureKey : String!
    
    let cellIDsArray = ["RadiusCell", "PriceCell", "OpenNowCell", "LeisureSiteCell"]
    let maxPriceArray = ["All", "€", "€€", "€€€", "€€€€"]
    let radiusArray = ["500", "1000", "1500", "2000", "2500", "3000", "3500", "4000", "4500", "5000"]
    let leisureTypes = [LeisureKeys.AmusementPark, LeisureKeys.ArtGallery, LeisureKeys.ShoppingMall, LeisureKeys.BowlingAlley, LeisureKeys.MovieTheater, LeisureKeys.NightClub, LeisureKeys.Casino, LeisureKeys.Museum, LeisureKeys.Church, LeisureKeys.Mosque, LeisureKeys.Stadium, LeisureKeys.Synagogue, LeisureKeys.Gym, LeisureKeys.Zoo]
    
    let leisureDictionary : [String:String] = [
        LeisureKeys.AmusementPark : GoogleConstants.SearchTypesValues.AmusementPark,
        LeisureKeys.ArtGallery : GoogleConstants.SearchTypesValues.ArtGallery,
        LeisureKeys.ShoppingMall : GoogleConstants.SearchTypesValues.ShoppingMall,
        LeisureKeys.BowlingAlley : GoogleConstants.SearchTypesValues.BowlingAlley,
        LeisureKeys.MovieTheater : GoogleConstants.SearchTypesValues.MovieTheater,
        LeisureKeys.NightClub : GoogleConstants.SearchTypesValues.NightClub,
        LeisureKeys.Casino : GoogleConstants.SearchTypesValues.Casino,
        LeisureKeys.Museum : GoogleConstants.SearchTypesValues.Museum,
        LeisureKeys.Church : GoogleConstants.SearchTypesValues.Church,
        LeisureKeys.Mosque : GoogleConstants.SearchTypesValues.Mosque,
        LeisureKeys.Synagogue : GoogleConstants.SearchTypesValues.Synagogue,
        LeisureKeys.Stadium : GoogleConstants.SearchTypesValues.Stadium,
        LeisureKeys.Gym : GoogleConstants.SearchTypesValues.Gym,
        LeisureKeys.Zoo : GoogleConstants.SearchTypesValues.Zoo]
    
    var radiusMenu : UIAlertController!
    var priceMenu : UIAlertController!
    var leisureMenu : UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(location.coordinate)
        
        let searchButton = UIBarButtonItem(title: "Search Places", style: .Plain, target: self, action: #selector(FilterOptionsViewController.didTapStartSearch))
        self.navigationItem.rightBarButtonItem = searchButton
        
        radiusMenu = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .ActionSheet)
        configureRadiusMenu()

        priceMenu = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .ActionSheet)
        configurePriceMenu()

        if typeOfPlace == .LeisureSites {
            leisureMenu = UIAlertController(title: nil, message: "Choose your Site", preferredStyle: .ActionSheet)
            configureLeisureMenu()
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
    }
    
    func didTapStartSearch() {

        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ShowPlacesViewController") as! ShowPlacesViewController
        
        let openNow = self.openNow.on
        if priceLabel.text == maxPriceArray[0] {
            controller.price = nil
        }
        else {
            let index = maxPriceArray.indexOf(priceLabel.text!)!
            controller.price = index
        }
        
        if typeOfPlace == .LeisureSites {
            controller.leisureType = leisureDictionary[leisureKey]
        } else { controller.leisureType = nil }
        
        controller.openNow = openNow
        controller.radius = radius
        controller.location = location.coordinate
        controller.typeOfPlace = typeOfPlace
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellID = cellIDsArray[indexPath.row]
        
        if cellID == "PriceCell" {
            presentViewController(priceMenu, animated: true, completion: nil)
        } else if cellID == "RadiusCell" {
            presentViewController(radiusMenu, animated: true, completion: nil)
        } else if cellID == "LeisureSiteCell" {
            presentViewController(leisureMenu, animated: true, completion: nil)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if typeOfPlace == .LeisureSites { return 4 }
        
        return 3
    }
    
    private func configureRadiusMenu() {
        
        for radius in radiusArray {
            let r = Double(radius)! / 1000
            let action = UIAlertAction(title: "\(r) Km", style: .Default) { (action) in
                
                performUIUpdatesOnMain { self.radiusLabel.text = "\(r) Km" }
                self.radius = Int(r * 1000)
                print(self.radius)
            }
            radiusMenu.addAction(action)
        }
    }

    private func configurePriceMenu() {
        
        for price in maxPriceArray {
            let action = UIAlertAction(title: price, style: .Default) { (action) in
                
                performUIUpdatesOnMain { self.priceLabel.text = price }
            }
            priceMenu.addAction(action)
        }
    }

    private func configureLeisureMenu() {
        
        for leisure in leisureTypes {
            let action = UIAlertAction(title: leisure, style: .Default) { (action) in
                
                performUIUpdatesOnMain {
                    self.leisureLabel.text = leisure
                    self.navigationItem.rightBarButtonItem!.enabled = true
                }
                self.leisureKey = leisure
            }
            leisureMenu.addAction(action)
        }
    }
}
