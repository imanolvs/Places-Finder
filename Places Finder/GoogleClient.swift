//
//  GoogleClient.swift
//  Places Finder
//
//  Created by Imanol Viana Sánchez on 9/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

class GoogleClient : NSObject {
    
    class func sharedInstance() -> GoogleClient {
        
        struct Singleton {
            static var instance = GoogleClient()
        }
        
        return Singleton.instance
    }
    
    var session : NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    let langArray = [GoogleConstants.Languages.Arabic, GoogleConstants.Languages.Bulgarian, GoogleConstants.Languages.Catalan, GoogleConstants.Languages.Czech, GoogleConstants.Languages.Danish, GoogleConstants.Languages.German, GoogleConstants.Languages.Greek, GoogleConstants.Languages.English, GoogleConstants.Languages.Spanish, GoogleConstants.Languages.Finnish, GoogleConstants.Languages.French, GoogleConstants.Languages.Hindi, GoogleConstants.Languages.Italian, GoogleConstants.Languages.Japanese, GoogleConstants.Languages.Korean, GoogleConstants.Languages.Lithuanian, GoogleConstants.Languages.Latvian, GoogleConstants.Languages.Dutch, GoogleConstants.Languages.Norwegian, GoogleConstants.Languages.Polish, GoogleConstants.Languages.Portuguese, GoogleConstants.Languages.Romanian, GoogleConstants.Languages.Russian, GoogleConstants.Languages.Swedish, GoogleConstants.Languages.Turkish, GoogleConstants.Languages.Ukrainian]
    
    func getValidLanguage() -> String {
        
        let lang = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        
        for l in langArray {
            
            if l == lang { return lang }
        }
        
        return GoogleConstants.Languages.English
    }
    
    private func showConnectionErrorAlert(error: NSError) {
        
        var vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        while vc!.presentedViewController != nil {
            vc = vc?.presentedViewController
        }
        let alert = UIAlertController(title: "Connection Error", message: "Error: \(error.code)", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(alertAction)
        performUIUpdatesOnMain { vc!.presentViewController(alert, animated: true, completion: nil) }
    }
    
    // MARK: Network Method for searching places though Google API
    private func taskForSearchPlace(parameters: [String:AnyObject], searchMethodType: String, completionHandler: (nextPageToken: String?, results: [[String:AnyObject]]?, error: String?) -> Void) -> NSURLSessionDataTask {
        
        var urlString = GoogleConstants.GooglePlaces.BaseURLMethod + searchMethodType
        for (key, value) in parameters {
            urlString += "\(key)=\(value)&"
        }
        urlString = String(urlString.characters.dropLast())
        
        let task = session.dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) in
            
            func sendError(error: String) {
                completionHandler(nextPageToken: nil, results: nil, error: error)
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with the request: \(error)")
                self.showConnectionErrorAlert(error!)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }

            var parsedResults : [String:AnyObject]!
            do { parsedResults = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String:AnyObject] }
            catch {
                completionHandler(nextPageToken: nil, results: nil, error: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let results = parsedResults[GoogleConstants.SearchResponseKeys.Results] else {
                completionHandler(nextPageToken: nil, results: nil, error: "No Results Found")
                return
            }

            let nextPageToken = parsedResults[GoogleConstants.SearchResponseKeys.NextPageToken] as? String
            let retResults = results as! [[String:AnyObject]]
            completionHandler(nextPageToken: nextPageToken, results: retResults, error: nil)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Network Method for getting a place details though Google API
    private func taskForDetailPlace(parameters: [String:AnyObject], completionHandler: (results: [String:AnyObject]?, error: String?) -> Void) -> NSURLSessionDataTask {
        
        var urlString = GoogleConstants.GooglePlaces.BaseURLMethod + GoogleConstants.Methods.DetailsMethod
        for (key, value) in parameters {
            urlString += "\(key)=\(value)&"
        }
        urlString = String(urlString.characters.dropLast())
        
        let task = session.dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) in
            
            func sendError(error: String) {
                completionHandler(results: nil, error: error)
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with the request: \(error)")
                self.showConnectionErrorAlert(error!)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            var parsedResults : [String:AnyObject]!
            do { parsedResults = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String:AnyObject] }
            catch {
                completionHandler(results: nil, error: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let results = parsedResults else {
                completionHandler(results: nil, error: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            completionHandler(results: results, error: nil)
        }
        
        task.resume()
        
        return task
    }
}


extension GoogleClient {
    
    func searchNearbyRestaurants(parameters : [String:AnyObject], completionHandler: (nextPageToken: String?, results: [[String:AnyObject]]?, error: String?) -> Void) {
        
        taskForSearchPlace(parameters, searchMethodType: GoogleConstants.Methods.NearbySearchMethod) { (nextPageToken, results, error) in
            
            guard error == nil else {
                completionHandler(nextPageToken: nil, results: nil, error: error)
                return
            }
            
            completionHandler(nextPageToken: nextPageToken, results: results, error: nil)
        }
    }
    
    func searchPlaceDetail(placeID: String, completionHander: (results: [String:AnyObject]?, error: String?) -> Void) {
        
        let parameters : [String:AnyObject] = [
            GoogleConstants.ParameterKeys.PlaceID : placeID,
            GoogleConstants.ParameterKeys.Language : getValidLanguage(),
            GoogleConstants.ParameterKeys.APIKey : GoogleConstants.GooglePlaces.APIKey]
        
        taskForDetailPlace(parameters) { (results, error) in
            
            guard error == nil else {
                completionHander(results: nil, error: error)
                return
            }
            
            let status = results![GoogleConstants.SearchResponseKeys.Status] as! String
            guard status == GoogleConstants.ResponseValues.OKStatus else {
                completionHander(results: nil, error: status)
                return
            }
            
            let details = results![GoogleConstants.DetailsResponseKeys.Result] as! [String:AnyObject]
            completionHander(results: details, error: nil)
        }
    }
    
    func getPhotoFromReference(photoReference: String, completionHandler: (data: NSData?, error: String?) -> Void) -> NSURLSessionDataTask {
        
        var urlString = GoogleConstants.GooglePlaces.BaseURLMethod + GoogleConstants.Methods.PhotoMethod
        urlString += "\(GoogleConstants.ParameterKeys.MaxWidth)=1080&\(GoogleConstants.ParameterKeys.PhotoReference)=\(photoReference)&\(GoogleConstants.ParameterKeys.APIKey)=\(GoogleConstants.GooglePlaces.APIKey)"
        
        let task = session.dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) in
            
            func sendError(error: String) {
                completionHandler(data: nil, error: error)
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with the request: \(error)")
                self.showConnectionErrorAlert(error!)
               return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            completionHandler(data: data, error: nil)
        }
        
        task.resume()
        
        return task
    }
}
