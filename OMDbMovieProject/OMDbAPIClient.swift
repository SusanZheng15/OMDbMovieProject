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
    var upcomingMovie : [UpcomingMovies] = []
    
    func getNextPage()
    {
        pageNumber += 1
    }
    
    func OMDbSearchAPIcall(_ searchedResult: String, completion: @escaping (NSArray)->())
    {
        
        let urlString = "https://www.omdbapi.com/?s=\(searchedResult)&page=\(pageNumber)"
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else {return}
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let movieSearched = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let moviesArray = movieSearched["Search"] as? NSArray
        
                guard let unwrappedMovies = moviesArray else {return}
                
                completion(unwrappedMovies)
                
            }
            catch
            {
                print("did i crash?")
            }
        }) 
        dataTask.resume()
        
    }
    
    
    func getMovieDetailAPICallWithID(_ id: String, completion: @escaping (NSDictionary)-> ())
    {
        let urlString = "http://www.omdbapi.com/?i=\(id)"
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else {return}
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let movieDetails = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                
                if let movieDetailDictionary = movieDetails
                {
                    completion(movieDetailDictionary)
                }
            }
            catch
            {
                print(error)
            }
        }) 
        dataTask.resume()

    }
    
    func getMovieFullPlot(_ id: String, completion: @escaping (NSDictionary)->())
    {
        let urlString = "https://www.omdbapi.com/?i=\(id)&plot=full"
        
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else {return}
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let movieDetailsFull = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                
                if let movieDetailDictionary = movieDetailsFull
                {
                    completion(movieDetailDictionary)
                }
            }
            catch
            {
                print(error)
            }
        }) 
        dataTask.resume()
    }
    
    func getMoviesPlayingInTheaters(_ completion: @escaping (NSArray)->())
    {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let upcomingMovie = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as! NSDictionary
                
                let moviesArray = upcomingMovie["results"] as? NSArray
                
                guard let unwrappedMovies = moviesArray else {return}
                
                for movie in unwrappedMovies
                {
                    let movieDict = UpcomingMovies.init(dictionary: movie as! NSDictionary)
                    self.upcomingMovie.append(movieDict)
                    completion(unwrappedMovies)
                }
                
            }
            catch
            {
                print("did i crash?")
            }
        }) 
        dataTask.resume()
     
    }
    
    func movieTrailerAPI(_ ID: Int, completion: @escaping (String)->())
    {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let urlString = "https://api.themoviedb.org/3/movie/\(ID)/videos?api_key=\(apiKey)"
        
        let url = URL(string: urlString)
        
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do{
                let upcomingMovie = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
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
        }) 
        dataTask.resume()
    }
    
    func checkIfAnyTrailersAvailable(_ ID: Int, completion: @escaping (NSArray)->())
    {
        
            let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            let urlString = "https://api.themoviedb.org/3/movie/\(ID)/videos?api_key=\(apiKey)"
            
            let url = URL(string: urlString)
            
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                guard let unwrappedData = data else {return}
                
                do{
                    let upcomingMovie = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    
                    let moviesTrailers = upcomingMovie["results"] as? NSArray
                    
                    guard let unwrappedMovies = moviesTrailers else {return}
                    
                    completion(unwrappedMovies)
                    
                }
                catch
                {
                    print("did i crash?")
                }
            }) 
            dataTask.resume()
        }
    
}
    
