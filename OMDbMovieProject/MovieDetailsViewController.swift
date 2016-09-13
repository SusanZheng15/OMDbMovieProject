//
//  MovieDetailsViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movie: Movie?
    
    let omdbMovie = MovieDataStore.sharedInstance
    
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
        
        self.title = movie?.title
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Movie", style: .Done, target: self, action: #selector(MovieDetailsViewController.saveMovie))
       // self.view.backgroundColor = UIColor.blackColor().
        //self.po
        
        guard let unwrappedMovie = movie else {return}
        self.omdbMovie.getDetailsFor(unwrappedMovie)
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
    
    
    @IBAction func plotDescriptionButton(sender: AnyObject)
    {
        //segue
    }
    
    func saveMovie()
    {
        print("save")
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
