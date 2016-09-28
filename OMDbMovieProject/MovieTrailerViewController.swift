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
    
    let store = MovieDataStore.sharedInstance

    let youtubeURL = "https://www.youtube.com/embed/"

    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        self.noTrailerLabel.hidden = true
        guard let id = movieID else {return}
        
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
                    
                    print(string)
                    self.movieTrailerWebView.loadHTMLString("<iframe width=\"560\" height=\"315\" src=\"\(self.youtubeURL+string)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
                
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
