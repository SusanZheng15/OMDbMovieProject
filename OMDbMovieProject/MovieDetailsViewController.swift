//
//  MovieDetailsViewController.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var plot: String = ""
    var movieImbdID = ""
    
    let omdbMovie = OMDbAPIClient.sharedInstance
    
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
        
    
            self.omdbMovie.getMovieDetailAPICallWithID(self.plot) { (dictionary) in
                
                self.moviePlot.text = dictionary["Plot"] as? String
                self.releasedLabel.text = dictionary["Released"] as? String
                self.directorLabel.text = dictionary["Director"] as? String
                self.writerLabel.text = dictionary["Writer"] as? String
                self.starsLabel.text = dictionary["Actors"] as? String
                self.imbdScoreLabel.text = dictionary["imdbRating"] as? String
                self.metaScoreLabel.text = dictionary["Metascore"] as? String
                let movieid = dictionary["imdbID"] as? String
             
                if let unwrappedMovieID = movieid
                {
                    self.movieImbdID = unwrappedMovieID
                }
                
                //        let stringPosterUrl = NSURL(string: (dictionary["Poster"] as! String))
                //
                //        if let url = stringPosterUrl
                //        {
                //            let dtinternet = NSData(contentsOfURL: url)
                //
                //            if let unwrappedImage = dtinternet
                //            {
                //                self.posterImageView.image = UIImage.init(data: unwrappedImage)
                //            }
                //        }
                
            }
        
        

        
    }

    
    @IBAction func plotDescriptionButton(sender: AnyObject)
    {
      //  self.performSegueWithIdentifier("movieDetailSegue", sender: self.movieImbdID)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "movieDetailSegue"
        {
            let destinationFullPlotVC = segue.destinationViewController as? FullPlotViewController
            
            destinationFullPlotVC?.fullPlotString = self.movieImbdID
        }
        
        
    }
    

}
