//
//  SearchedTrailerViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 10/4/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SearchedTrailerViewController: UIViewController
{
    
    let youtubeURL = "https://www.youtube.com/embed/"
    
    var youTubeVideoHTML: String = "<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%0.0f', height:'%0.0f', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>"

    var movieTrailer : Movie?
    
    let store = MovieDataStore.sharedInstance

    @IBOutlet weak var trailerWebView: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let movieID = movieTrailer?.imdbID
        {
            self.store.api.movieTrailerAPIWithString(movieID, completion: { (stringID) in
                DispatchQueue.main.async { () -> Void in
                
                    self.trailerWebView.mediaPlaybackRequiresUserAction = false
                    self.trailerWebView.allowsInlineMediaPlayback = true
                    
                    let html: String = String(format: self.youTubeVideoHTML, self.trailerWebView.frame.size.width, self.trailerWebView.frame.size.height, stringID)
                    
                    self.trailerWebView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
                       
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
