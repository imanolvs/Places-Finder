//
//  AddressViewController.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 20/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit
import MapKit

class AddressViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude : Double!
    var longitude : Double!
    var address : String!
    var name : String!
    var photoReference : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = address
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = name
        
        mapView.region.center = annotation.coordinate
        mapView.region.span = MKCoordinateSpanMake(0.02, 0.02)
        mapView.addAnnotation(annotation)        
    }
    
    @IBAction func showRoute() {
        
        let url = "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=d&t=h"
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    @IBAction func showUserLocation() {
        
        let annA = mapView.annotations[0]
        let annB = mapView.annotations[1]
        
        let center = CLLocationCoordinate2DMake((annA.coordinate.latitude+annB.coordinate.latitude)/2, (annA.coordinate.longitude+annB.coordinate.longitude)/2)
        
        var latDiff = annA.coordinate.latitude - annB.coordinate.latitude
        var lonDiff = annA.coordinate.longitude - annB.coordinate.longitude
        
        if latDiff < 0 { latDiff = -latDiff }
        if lonDiff < 0 { lonDiff = -lonDiff }
        
        mapView.region.center = center
        mapView.region.span = MKCoordinateSpan(latitudeDelta: latDiff + 1, longitudeDelta: lonDiff + 1)
    }
}

// MARK: Map View Delegate methods
extension AddressViewController {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKUserLocation) { return nil }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if pinView == nil {
            
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
            let pinImage = UIImage(named: "LocationCircle")
            let size = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContext(size)
            pinImage!.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            pinView!.image = resizedImage
            pinView!.opaque = false
            pinView!.alpha = 0.8
            pinView!.draggable = false
            pinView!.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if view.annotation!.isKindOfClass(MKUserLocation) { return }
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        imageView.contentMode = .ScaleToFill
        
        if photoReference == nil {
            imageView.image = UIImage(named: "noimage")!
        }
        else if let image = retrievePhotoImage(photoReference!) {
            imageView.image = image
        }
        else { imageView.image = nil }
        
        view.leftCalloutAccessoryView = imageView
    }
    

}

extension AddressViewController {
    
    private func retrievePhotoImage(photoReference: String) -> UIImage? {
        
        return ImageCache.sharedInstance().imageWithIdentifier(photoReference)
    }
}