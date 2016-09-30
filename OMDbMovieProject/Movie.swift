//
//  OMDBMovieDictionary.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class Movie: NSManagedObject
{
    
    convenience init(dictionary: NSDictionary,entity: NSEntityDescription, managedObjectContext: NSManagedObjectContext)
    {
        self.init(entity: entity, insertInto: managedObjectContext)

        guard let
            movieTitle = dictionary["Title"] as? String,
            let moviePoster = dictionary["Poster"] as? String,
            let movieYear = dictionary["Year"] as? String,
            let movieID = dictionary["imdbID"] as? String
        
            else { fatalError("Could not create object from supplied dictionary") }
        
        
            self.title = movieTitle
            self.poster = moviePoster
            self.year = movieYear
            self.imdbID = movieID

    }

    func updateMovieDetailsFrom(_ dictionary: NSDictionary, completion:(Bool) -> ())
    {
        self.plot = dictionary["Plot"] as? String
        self.actors = dictionary["Actors"] as? String
        self.released = dictionary["Released"] as? String
        self.director = dictionary["Director"] as? String
        self.writer = dictionary["Writer"] as? String
        self.imdbRating = dictionary["imdbRating"] as? String
        self.metaScore = dictionary["Metascore"] as? String
        
        completion(true)
    }
    
    func updateMovieWithFullSummary(_ dictionary: NSDictionary, completion:(Bool)->())
    {
        self.fullSummary = dictionary["Plot"] as? String
        completion(true)
    }
    
}
