//
//  MovieDetailsViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailsViewController: UIViewController
{
    var movie: Movie?
    
    let omdbMovie = MovieDataStore.sharedInstance
    
    @IBOutlet weak var backColoring: UIView!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var imbdScoreLabel: UILabel!
    @IBOutlet weak var metaScoreLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        omdbMovie.fetchData()
        checkForData()
        
        self.backColoring.backgroundColor = UIColor.darkGrayColor()
        self.title = movie?.title
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(MovieDetailsViewController.saveMovie))
    }
    
    
     func checkForData()
     {
        let userRequest = NSFetchRequest(entityName: "Favorites")
     
        do{
            let object = try omdbMovie.managedObjectContext.executeFetchRequest(userRequest) as! [Favorites]
            guard let movieObject = self.movie else {return}
            
            if object.count == 0
            {
                print("theres nothing in core data")
                self.omdbMovie.getDetailsFor(movieObject)
                {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.moviePlot.text = self.movie?.plot
                        self.releasedLabel.text = self.movie?.released
                        self.directorLabel.text = self.movie?.director
                        self.writerLabel.text = self.movie?.writer
                        self.starsLabel.text = self.movie?.actors
                        self.imbdScoreLabel.text = self.movie?.imdbRating
                        self.metaScoreLabel.text = self.movie?.metaScore
                        
                        
                        let imageString = self.movie?.poster
                        
                        if let unwrappedString = imageString
                        {
                            let stringPosterUrl = NSURL(string: unwrappedString)
                            if let url = stringPosterUrl
                            {
                                let dtinternet = NSData(contentsOfURL: url)
                                
                                if let unwrappedImage = dtinternet
                                {
                                    self.posterImageView.image = UIImage.init(data: unwrappedImage)
                                }
                            }
                            
                        }
                    })
                }
                
            }
    
            for movie in object
            {
                guard let savedMovieID = movie.movies?.first?.imdbID else {return}
                
               if object.count != 0 && savedMovieID == movieObject.imdbID
                {
                    print("Has it")
                    self.moviePlot.text = movie.movies?.first?.plot
                    self.releasedLabel.text = movie.movies?.first?.released
                    self.directorLabel.text = movie.movies?.first?.director
                    self.writerLabel.text = movie.movies?.first?.writer
                    self.starsLabel.text = movie.movies?.first?.actors
                    self.imbdScoreLabel.text = movie.movies?.first?.imdbRating
                    self.metaScoreLabel.text = movie.movies?.first?.metaScore
                    
                    let imageString = movie.movies?.first?.poster
                    
                    if let unwrappedString = imageString
                    {
                        let stringPosterUrl = NSURL(string: unwrappedString)
                        if let url = stringPosterUrl
                        {
                            let dtinternet = NSData(contentsOfURL: url)
                            
                            if let unwrappedImage = dtinternet
                            {
                                self.posterImageView.image = UIImage.init(data: unwrappedImage)
                            }
                        }
                        
                    }
                }
                else if object.count != 0 && savedMovieID != movieObject.imdbID
                {
                    print("doesnt have it")
                    self.omdbMovie.getDetailsFor(movieObject)
                    {
                        dispatch_async(dispatch_get_main_queue(),{
                            self.moviePlot.text = self.movie?.plot
                            self.releasedLabel.text = self.movie?.released
                            self.directorLabel.text = self.movie?.director
                            self.writerLabel.text = self.movie?.writer
                            self.starsLabel.text = self.movie?.actors
                            self.imbdScoreLabel.text = self.movie?.imdbRating
                            self.metaScoreLabel.text = self.movie?.metaScore
                            
                            
                            let imageString = self.movie?.poster
                            
                            if let unwrappedString = imageString
                            {
                                let stringPosterUrl = NSURL(string: unwrappedString)
                                if let url = stringPosterUrl
                                {
                                    let dtinternet = NSData(contentsOfURL: url)
                                    
                                    if let unwrappedImage = dtinternet
                                    {
                                        self.posterImageView.image = UIImage.init(data: unwrappedImage)
                                    }
                                }
                                
                            }
                            })
                        }
                    }
                
                }
            
            }
            
            catch{print("Error")}
        
    }
    
    
    @IBAction func plotDescriptionButton(sender: AnyObject)
    {
        //segue
    }
    
    func saveMovie()
    {
        guard let savedMovieTitle = self.movie?.title else {return}
        let saveAlert = UIAlertController.init(title: "Saved", message: "\(savedMovieTitle) has been saved to favorites", preferredStyle: .Alert)
        
        let okayAction = UIAlertAction.init(title: "Okay", style: .Cancel) { (action) in
        }
        saveAlert.addAction(okayAction)
        self.presentViewController(saveAlert, animated: true){
        }
        
        let context = omdbMovie.managedObjectContext
    
        let addMovie = NSEntityDescription.insertNewObjectForEntityForName("Favorites", inManagedObjectContext: context) as! Favorites
        
        guard let savedMovie = self.movie else {return}
        addMovie.movies?.insert(savedMovie)
        
        print(addMovie.movies)
        
        omdbMovie.saveContext()
        
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "fullSummarySegue"
        {
            let destinationFullPlotVC = segue.destinationViewController as? FullPlotViewController
            
            if let unwrappedMovie = movie
            {
                destinationFullPlotVC?.movie = unwrappedMovie
            }
            
        }
        
    }

}
