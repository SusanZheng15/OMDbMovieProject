//
//  OMDBMovieDictionary.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class OMDBMovie
{
    var title: String
    var poster: String
    var type: String
    var year: String
    var imdbID: String
        
    init(dictionary: NSDictionary)
    {
        guard let
        movieTitle = dictionary["Title"] as? String,
        moviePoster = dictionary["Poster"] as? String,
        movieType = dictionary["Type"] as? String,
        movieYear = dictionary["Year"] as? String,
        movieID = dictionary["imdbID"] as? String
            
        else { fatalError("Could not create object from supplied dictionary") }
        
        self.title = movieTitle
        self.poster = moviePoster
        self.type = movieType
        self.year = movieYear
        self.imdbID = movieID
        
    }
        
    
    
}