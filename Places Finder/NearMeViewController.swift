//
//  NearMeViewController.swift
//  Moving in Madrid
//
//  Created by Imanol Viana Sánchez on 8/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import MapKit

class NearMeViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var mapView : MKMapView!
    
    override func viewDidLoad() {
        if revealViewController() != nil {
//            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
//
//            revealViewController().rightViewRevealWidth = 150
//            extraButton.target = revealViewController()
//            extraButton.action = "rightRevealToggle:"
//            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        findNearStops()
    }
    
    func findNearStops() {
        
        //Parque del Retiro
        let latitude : Double = 40.4154
        let longitude : Double = -3.6842
        let radius : Int = 500
//        let stopID : Int = 1200
        
        var stops : [Stop] = []
        
         let parameters : [String:AnyObject] = [
            EMTConstants.GetStopsFromXYKeys.ClientID : EMTConstants.EMT.ClientID,
            EMTConstants.GetStopsFromXYKeys.PassKey : EMTConstants.EMT.APIKey,
            EMTConstants.GetStopsFromXYKeys.Latitude : latitude,
            EMTConstants.GetStopsFromXYKeys.Longitude : longitude,
            EMTConstants.GetStopsFromXYKeys.Radius : radius]
                
        EMTClient.sharedInstance().performEMTRequest(EMTConstants.Methods.GetStopsFromXY, parameters: parameters) { (results, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            
            print(results)
            let stopArray = results![EMTConstants.GetStopsFromXYResponseKeys.Stop] as! [[String:AnyObject]]
            
            for dictionary in stopArray {
                
                let stop = Stop()
                stop.latitude = dictionary[EMTConstants.GetStopsFromXYResponseKeys.Latitude] as! Double
                stop.longitude = dictionary[EMTConstants.GetStopsFromXYResponseKeys.Longitude] as! Double
                stop.stopID = dictionary["stopId"] as! String
                stop.name = dictionary["name"] as! String
                stops.append(stop)
            }

            for s in stops {
                print(s.name)
                print(s.stopID)
                performUIUpdatesOnMain { self.mapView.addAnnotation(s) }
            }
        }
        
//        parameters = [
//            EMTConstants.GetStopsFromXYKeys.ClientID : EMTConstants.EMT.ClientID,
//            EMTConstants.GetStopsFromXYKeys.PassKey : EMTConstants.EMT.APIKey,
//            "idStop" : stopID]
//        
//        EMTClient.sharedInstance().performEMTRequest(EMTConstants.Methods.GetStopsFromStop, parameters: parameters) { (results, error) in
//            
//            guard error == nil else {
//                print(error)
//                return
//            }
//            
//            print(results)
//        }
    }
}

// MARK: Map View Delegate Methods
extension NearMeViewController {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "stop"
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        
        pinView.pinTintColor = UIColor.redColor()
        pinView.draggable = false
        pinView.canShowCallout = false
        pinView.animatesDrop = true
        
        return pinView
    }
}