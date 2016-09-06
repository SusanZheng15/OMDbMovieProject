//
//  OMDbSearchAPI.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class OMDbAPIClient
{
    
    static let sharedInstance = OMDbAPIClient()
    
    var movieArray : [OMDBMovie] = []
    
    func OMDbSearchAPIcall(searchedResult: String, completion: (NSArray)->())
    {
        let urlString = "https://www.omdbapi.com/?s=\(searchedResult)"
        let url = NSURL(string: urlString)
        
        guard let unwrappedURL = url else {return}
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let movieSearched = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments)
                
                
                let moviesArray = movieSearched["Search"] as? NSArray
            
                guard let unwrappedMovies = moviesArray else {return}
                
                for movie in unwrappedMovies
                {
                    let movieDict = OMDBMovie.init(dictionary: movie as! NSDictionary)
                    self.movieArray.append(movieDict)
                }
                if self.movieArray.count > 0
                {
                    completion(unwrappedMovies)
                }

            }
            catch
            {
                print(error)
            }
        }
        dataTask.resume()
        
        }
        
    }
    
