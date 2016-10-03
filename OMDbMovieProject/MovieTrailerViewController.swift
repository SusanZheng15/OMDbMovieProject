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
        self.goBackToFirstButton.layer.borderColor = UIColor.purple.cgColor
        self.goBackToFirstButton.layer.cornerRadius = 10
        self.goBackToFirstButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.titleLabel.isHidden = true
        self.releaseDateLabel.isHidden = true
        self.overviewTextView.isHidden = true
        
         store.api.checkIfAnyTrailersAvailable(id) { (results) in
            
            if results == []
            {
                self.movieTrailerWebView.isHidden = true
                self.noTrailerLabel.isHidden = false
                self.noTrailerLabel.text = "No Trailers Available"
                print("no trailers")
            }
            else
            {
                self.movieTrailerWebView.isHidden = false
                self.noTrailerLabel.isHidden = true
                
                self.store.api.movieTrailerAPI(id) { (string) in
    
                    OperationQueue.main.addOperation({
                        let width = self.movieTrailerWebView.frame.width
                        let height = self.movieTrailerWebView.frame.height
                        self.movieTrailerWebView.loadHTMLString("<iframe width=\"\(width)\" height=\(height)\" src=\"\(self.youtubeURL+string)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
                        self.movieTrailerWebView.backgroundColor = UIColor.clear
                    })
                    
                }
            
            }
            
            OperationQueue.main.addOperation({ 
                if let title = self.movieTitle
                {
                    self.titleLabel.isHidden = false
                    self.titleLabel.text = title
                }
                if let date = self.releaseDate
                {
                    self.releaseDateLabel.isHidden = false
                    self.releaseDateLabel.text = date
                }
                if let plot = self.overview
                {
                    self.overviewTextView.isHidden = false
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
