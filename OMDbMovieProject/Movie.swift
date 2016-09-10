//
//  OMDBMovieDictionary.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class Movie
{
    var title: String
    var poster: String
    var type: String
    var year: String
    var imdbID: String
    var plot: String?
    var released: String?
    var director: String?
    var writer: String?
    var actors: String?
    var imdbRating: String?
    var metaScore: String?
    var fullSummary: String?
   // var posterImage: uiim
 
    
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

    func updateMovieDetailsFrom(dictionary: NSDictionary, completion:(Bool) -> ())
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
    
    func updateMovieWithFullSummary(dictionary: NSDictionary, completion:(Bool)->())
    {
        self.fullSummary = dictionary["Plot"] as? String
        completion(true)
    }
//    
//    func convertPosterUrlToImage(urlString: String, completion: (Bool)->())
//    {
//         dispatch_async(dispatch_get_main_queue(),{
//            let stringPosterUrl = NSURL(string: self.poster)
//            
//            if self.poster == "N/A"
//            {
//                self.posterImage = UIImage.init(named: "pikachu.png")
//            }
//            if let url = stringPosterUrl
//            {
//                let dtinternet = NSData(contentsOfURL: url)
//            
//                if let unwrappedImage = dtinternet
//                {
//                    self.posterImage = UIImage.init(data: unwrappedImage)
//                    completion(true)
//                }
//            }
//        })
//        
//    }

}
