//
//  OMDbSearchAPI.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class OMDbSearchAPI
{
    class func OMDbSearchAPIcall(textField: String, completion: NSDictionary->())
    {
        let urlString = "https://www.omdbapi.com/?s=\(textField)"
        
        let url = NSURL(string: urlString)
        
        guard let unwrappedURL = url else {return}
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let movieSearchDictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                guard let unwrappedDictionary = movieSearchDictionary else {return}
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    completion(unwrappedDictionary)
                })
               
                
            }
            catch
            {
                print(error)
            }
        }
        task.resume()
    }
}