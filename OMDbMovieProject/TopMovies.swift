//
//  topMovies.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class TopMovies
{
    var title: String
    var poster: String
    var releaseDate: String
    var plot : String

    
    init(dictionary: NSDictionary)
    {
        guard let
        movieTitle = dictionary["title"] as? String,
        moviePoster = dictionary["poster_path"] as? String,
        movieDate = dictionary["release_date"] as? String,
        moviePlot = dictionary["overview"] as? String
    
        else { fatalError("Could not create object from supplied dictionary") }
    
        self.title = movieTitle
        self.poster = moviePoster
        self.releaseDate = movieDate
        self.plot = moviePlot
            
    }
    
}
