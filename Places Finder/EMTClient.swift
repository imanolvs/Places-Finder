//
//  EMTClient.swift
//  Moving in Madrid
//
//  Created by Imanol Viana Sánchez on 9/3/16.
//  Copyright © 2016 Imanol Viana Sánchez. All rights reserved.
//

import UIKit

class EMTClient : NSObject, NSURLSessionDelegate {
    
    class func sharedInstance() -> EMTClient {
        
        struct Singleton {
            static var instance = EMTClient()
        }
        
        return Singleton.instance
    }
    
    private func taskForEMTRequest(method: String, stringBody: String, completionHandler: (results: [String:AnyObject]?, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let methodString = EMTConstants.EMT.BaseURLMethod + method
        let url = NSURL(string: methodString)!

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlRequest: NSURLRequest = NSURLRequest(URL: url)
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = stringBody.dataUsingEncoding(NSUTF8StringEncoding)

        print(stringBody)
        print(url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                completionHandler(results: nil, error: error)
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError("There was an error with the request: \(error)")
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

extension EMTClient {
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
}

extension EMTClient {
    
    func performEMTRequest(method: String, parameters: [String:AnyObject], completionHandler: (result: [String:AnyObject]?, error: String?) -> Void) {
        
        var stringBody : String = ""
        for (key, value) in parameters {
            stringBody += "\(key)=\(value)&"
        }
        stringBody = String(stringBody.characters.dropLast())
        
        taskForEMTRequest(method, stringBody: stringBody) { (results, error) in
            
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            completionHandler(result: results, error: error)
        }
    }
}
