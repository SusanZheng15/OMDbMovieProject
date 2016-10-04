//
//  SearchedTrailerViewController.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 10/4/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SearchedTrailerViewController: UIViewController
{
    
    let youtubeURL = "https://www.youtube.com/embed/"
    var movieTrailer : Movie?
    
    let store = MovieDataStore.sharedInstance

    @IBOutlet weak var trailerWebView: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        print("did it go through?")
        if let movieID = movieTrailer?.imdbID
        {
           print("whats goign on?")
            self.store.api.movieTrailerAPIWithString(movieID, completion: { (string) in
                DispatchQueue.main.async { () -> Void in
                    let width = self.trailerWebView.frame.width
                    let height = self.trailerWebView.frame.height
                        
                    self.trailerWebView.loadHTMLString("<iframe width=\"\(width)\" height=\(height)\" src=\"\(self.youtubeURL+string)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
                    self.trailerWebView.mediaPlaybackRequiresUserAction = false
                       
                }
            })
        }
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
