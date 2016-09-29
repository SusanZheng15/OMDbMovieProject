//
//  MovieTrailerViewController.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MovieTrailerViewController: UIViewController {
    
    @IBOutlet weak var movieTrailerWebView: UIWebView!
    
    @IBOutlet weak var noTrailerLabel: UILabel!
    var movieID : Int?
    
    @IBOutlet weak var goBackToFirstButton: UIButton!
    let store = MovieDataStore.sharedInstance

    let youtubeURL = "https://www.youtube.com/embed/"

    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        self.noTrailerLabel.hidden = true
        guard let id = movieID else {return}
        
        self.goBackToFirstButton.layer.borderWidth = 1
        self.goBackToFirstButton.layer.borderColor = UIColor.greenColor().CGColor
        self.goBackToFirstButton.layer.cornerRadius = 10
        self.goBackToFirstButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
         store.api.checkIfAnyTrailersAvailable(id) { (results) in
            
            if results == []
            {
                self.movieTrailerWebView.hidden = true
                self.noTrailerLabel.hidden = false
                print("no trailers")
            }
            else
            {
                self.store.api.movieTrailerAPI(id) { (string) in
                    
                    let width = self.movieTrailerWebView.frame.width
                    let height = self.movieTrailerWebView.frame.height
                    print(string)
                    self.movieTrailerWebView.loadHTMLString("<iframe width=\"\(width)\" height=\(height)\" src=\"\(self.youtubeURL+string)\" frameborder=\"30\" allowfullscreen></iframe>", baseURL: nil)
                
                }
            
            }
        
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
