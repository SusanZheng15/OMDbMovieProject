//
//  MovieTrailerViewController.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MovieTrailerViewController: UIViewController
{
    
    @IBOutlet weak var movieTrailerWebView: UIWebView!
    @IBOutlet weak var noTrailerLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goBackToFirstButton: UIButton!
    
    let store = MovieDataStore.sharedInstance
    var movieID : Int?
    var movieTitle : String?
    var releaseDate : String?
    var overview : String?
    
    let youtubeURL = "https://www.youtube.com/embed/"

    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        guard let id = movieID else {return}
        
        self.goBackToFirstButton.layer.borderWidth = 1
        self.goBackToFirstButton.layer.borderColor = UIColor.greenColor().CGColor
        self.goBackToFirstButton.layer.cornerRadius = 10
        self.goBackToFirstButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        self.titleLabel.hidden = true
        self.releaseDateLabel.hidden = true
        self.overviewTextView.hidden = true
        
         store.api.checkIfAnyTrailersAvailable(id) { (results) in
            
            if results == []
            {
                self.movieTrailerWebView.hidden = true
                self.noTrailerLabel.hidden = false
                self.noTrailerLabel.text = "No Trailers Available"
                print("no trailers")
            }
            else
            {
                self.movieTrailerWebView.hidden = false
                self.noTrailerLabel.hidden = true
                
                self.store.api.movieTrailerAPI(id) { (string) in
                    let width = self.movieTrailerWebView.frame.width
                    let height = self.movieTrailerWebView.frame.height
                    self.movieTrailerWebView.loadHTMLString("<iframe width=\"\(width)\" height=\(height)\" src=\"\(self.youtubeURL+string)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
                }
            
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                if let title = self.movieTitle
                {
                    self.titleLabel.hidden = false
                    self.titleLabel.text = title
                }
                if let date = self.releaseDate
                {
                    self.releaseDateLabel.hidden = false
                    self.releaseDateLabel.text = date
                }
                if let plot = self.overview
                {
                    self.overviewTextView.hidden = false
                    self.overviewTextView.text = plot
                }
            })
          
            
        
        }
        
      
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
