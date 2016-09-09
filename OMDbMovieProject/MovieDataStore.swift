//
//  MovieDataStore.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class MovieDataStore
{
    static let sharedInstance = MovieDataStore()
    
    let api = OMDbAPIClient.sharedInstance
    
    private init() {}
    
    var movieArray : [Movie] = []
    
    
    func getMovieRepositories(searched: String, completion: ()->())
    {

        api.OMDbSearchAPIcall(searched) { (array) in
            
            for dictionary in array
            {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in array is of non-dictionary type") }
                let repo = Movie(dictionary: repoDictionary)
                self.movieArray.append(repo)
            }
            completion()
        }
    }
    
    func getDetailsFor(movie: Movie, completion: ()->())
    {
        api.getMovieDetailAPICallWithID(movie.imdbID) { (dictionary) in
            
            movie.updateMovieDetailsFrom(dictionary, completion: { success in
                if success {
                    completion()
                }
            })
        }
    }
    func getFullSummary(movie: Movie, completion: ()->())
    {
        api.getMovieFullPlot(movie.imdbID) { (dictionary) in
            movie.updateMovieWithFullSummary(dictionary, completion: { (successful) in
                if successful
                {
                    completion()
                }
            })
        }
    }
   
}

