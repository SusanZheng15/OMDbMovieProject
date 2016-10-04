//
//  MovieTrailerViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MovieTrailerViewController: UIViewController
{
    
    @IBOutlet weak var movieTrailerWebView: UIWebView!
    
    
    @IBOutlet weak var noTrailerLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
   
    
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
        
        self.releaseDateLabel.isHidden = true
        self.overviewTextView.isHidden = true
        self.title = movieTitle
        checkStatus()
        
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
    
                    DispatchQueue.main.async { () -> Void in
                        
                        let youTubeVideoHTML: String = "<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%0.0f', height:'%0.0f', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>"
                        
                        
                        let html: String = String(format: youTubeVideoHTML, self.movieTrailerWebView.frame.size.width, self.movieTrailerWebView.frame.size.height, string)
                        
                        self.movieTrailerWebView.loadHTMLString(html, baseURL: nil)
                        self.movieTrailerWebView.mediaPlaybackRequiresUserAction = false
                        self.movieTrailerWebView.backgroundColor = UIColor.clear
        
                    }
                }
            
            }
            
            OperationQueue.main.addOperation({ 
               
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
    
    func checkStatus()
    {
        guard let id = movieID else {return}
        store.api.checkIfAnyTrailersAvailableStatusCodeWithInt(id) { (result) in
            if result == 34
            {
                self.movieTrailerWebView.isHidden = true
                self.noTrailerLabel.isHidden = false
                self.noTrailerLabel.text = "No Trailers Available"
                self.view.bringSubview(toFront: self.noTrailerLabel)
                print("no trailers")
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
