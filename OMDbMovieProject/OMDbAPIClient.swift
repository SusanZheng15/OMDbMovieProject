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
    var upcomingMovie : [TopMovies] = []
    
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
    
    func getMoviesPlayingInTheaters(completion: NSArray->())
    {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)"
        
        let url = NSURL(string: urlString)
        
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url!) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let upcomingMovie = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments)
                
                let moviesArray = upcomingMovie["results"] as? NSArray
                
                guard let unwrappedMovies = moviesArray else {return}
                
                for movie in unwrappedMovies
                {
                    let movieDict = TopMovies.init(dictionary: movie as! NSDictionary)
                    self.upcomingMovie.append(movieDict)
                    completion(unwrappedMovies)
                }
                
            }
            catch
            {
                print("did i crash?")
            }
        }
        dataTask.resume()
     
    }
    
    func movieTrailerAPI(ID: Int, completion: String->())
    {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let urlString = "https://api.themoviedb.org/3/movie/\(ID)/videos?api_key=\(apiKey)"
        
        let url = NSURL(string: urlString)
        
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url!) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let upcomingMovie = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments)
                
                let moviesTrailers = upcomingMovie["results"] as? NSArray
                
                guard let unwrappedMovies = moviesTrailers?.firstObject else {return}
                
                let firstMovie = unwrappedMovies as! NSDictionary
                
                let movieKey = firstMovie["key"] as? String
                guard let key = movieKey else {return}
                    
                completion(key)
                
            }
            catch
            {
                print("did i crash?")
            }
        }
        dataTask.resume()
    }
    
    func checkIfAnyTrailersAvailable(ID: Int, completion: NSArray->())
    {
        
            let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            let urlString = "https://api.themoviedb.org/3/movie/\(ID)/videos?api_key=\(apiKey)"
            
            let url = NSURL(string: urlString)
            
            
            let session = NSURLSession.sharedSession()
            
            let dataTask = session.dataTaskWithURL(url!) { (data, response, error) in
                
                guard let unwrappedData = data else {return}
                
                do{
                    let upcomingMovie = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments)
                    
                    let moviesTrailers = upcomingMovie["results"] as? NSArray
                    
                    guard let unwrappedMovies = moviesTrailers else {return}
                    
                    completion(unwrappedMovies)
                    
                }
                catch
                {
                    print("did i crash?")
                }
            }
            dataTask.resume()
        }
    
}
    
