//
//  topMovies.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class UpcomingMovies
{
    var title: String?
    var poster: String?
    var releaseDate: String?
    var plot : String?
    var id : Int?
    
    
    init(dictionary: NSDictionary)
    {
        if let moviePoster = dictionary["poster_path"]
        {
            self.poster = moviePoster as? String
        }
        else
        {
            self.poster = "pikachu.png"
        }
        if let movieTitle = dictionary["title"]
        {
            self.title = movieTitle as? String
        }
        if let movieDate = dictionary["release_date"]
        {
            self.releaseDate = movieDate as? String
        }
        if let moviePlot = dictionary["overview"]
        {
            self.plot = moviePlot as? String
        }
        if let movieID = dictionary["id"]
        {
            self.id = movieID as? Int
        }
        else
        {
            fatalError("Could not create object from supplied dictionary")
        }
        
        
    }
    
}
