//
//  OMDbSearchAPI.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class OMDbAPIClient
{

    static let sharedInstance = OMDbAPIClient()

    var pageNumber = 1
    
    func getNextPage()
    {
        pageNumber += 1
    }
    
    func OMDbSearchAPIcall(searchedResult: String, completion: (NSArray)->())
    {
        
        let urlString = "https://www.omdbapi.com/?s=\(searchedResult)&page=\(pageNumber)"
        let url = NSURL(string: urlString)
        
        guard let unwrappedURL = url else {return}
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let movieSearched = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments)
                
                let moviesArray = movieSearched["Search"] as? NSArray
        
                guard let unwrappedMovies = moviesArray else {return}
                
                completion(unwrappedMovies)
                
            }
            catch
            {
                print("did i crash?")
            }
        }
        dataTask.resume()
        
    }
    
    
    func getMovieDetailAPICallWithID(id: String, completion: (NSDictionary)-> ())
    {
        let urlString = "http://www.omdbapi.com/?i=\(id)"
        let url = NSURL(string: urlString)
        
        guard let unwrappedURL = url else {return}
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let movieDetails = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if let movieDetailDictionary = movieDetails
                {
                    completion(movieDetailDictionary)
                }
            }
            catch
            {
                print(error)
            }
        }
        dataTask.resume()

    }
    
    func getMovieFullPlot(id: String, completion: (NSDictionary)->())
    {
        let urlString = "https://www.omdbapi.com/?i=\(id)&plot=full"
        
        let url = NSURL(string: urlString)
        
        guard let unwrappedURL = url else {return}
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let movieDetailsFull = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if let movieDetailDictionary = movieDetailsFull
                {
                    completion(movieDetailDictionary)
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
    
