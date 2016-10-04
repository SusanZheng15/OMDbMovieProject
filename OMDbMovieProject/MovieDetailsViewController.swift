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
    var movieID: String?
    let youtubeURL = "https://www.youtube.com/embed/"

    
    let omdbMovie = MovieDataStore.sharedInstance
    
   
    @IBOutlet weak var releaseTemp: UILabel!
    @IBOutlet weak var dicrectorTemp: UILabel!
    @IBOutlet weak var writerTemp: UILabel!
    @IBOutlet weak var starsTemp: UILabel!
    @IBOutlet weak var imdbTemp: UILabel!
    @IBOutlet weak var metaTemp: UILabel!
    @IBOutlet weak var fullDescripTemp: UIButton!

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var imbdScoreLabel: UILabel!
    @IBOutlet weak var metaScoreLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var moviePlotTextField: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    @IBOutlet weak var trailerButtonOutlet: UIButton!
    
    @IBOutlet weak var trailerPic: UIImageView!
    @IBOutlet weak var trailerLabel: UILabel!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        checkIfTrailerExist()
        checkingStatusCode()
        
        self.releaseTemp.isHidden = true
        self.dicrectorTemp.isHidden = true
        self.writerTemp.isHidden = true
        self.starsTemp.isHidden = true
        self.metaTemp.isHidden = true
        self.posterImage.isHidden = true
        self.fullDescripTemp.isHidden = true
        self.imdbTemp.isHidden = true
        
        omdbMovie.fetchData()
        checkForData()
        reachabilityStatusChanged()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MovieDetailsViewController.reachabilityStatusChanged), name: NSNotification.Name(rawValue: "reachStatusChanged"), object: nil)
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.tabBarController?.navigationItem.title = movie?.title
        self.title = movie?.title
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "⭐️", style: .done, target: self, action: #selector(MovieDetailsViewController.saveMovie))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Apple SD Gothic Neo", size: 25)!], for: UIControlState())
       
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        
    }
    
 
    func reachabilityStatusChanged()
    {
        if reachabilityStatus == kNOTREACHABLE
        {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            let noNetworkAlertController = UIAlertController(title: "No Network Connection detected", message: "Cannot conduct search", preferredStyle: .alert)
            
            self.present(noNetworkAlertController, animated: true, completion: nil)
            
            DispatchQueue.main.async { () -> Void in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                    noNetworkAlertController.dismiss(animated: true, completion: nil)
                })
            }

        }
        else if reachabilityStatus == kREACHABILITYWITHWIFI
        {
            
        }
        else if reachabilityStatus == kREACHABLEWITHWWAN
        {

        }
    }
    
    
    func checkIfTrailerExist()
    {
        if let imdbID = movie?.imdbID
        {
           omdbMovie.api.checkIfAnyTrailersAvailableWithString(imdbID, completion: { (results) in
                if results == []
                {
                    self.trailerButtonOutlet.isHidden = true
                }
                else if results != []
                {
                    self.trailerButtonOutlet.isHidden = false
                }
                    
            })
            
            
        }
        
        
    }
    
    func checkingStatusCode()
    {
        if let id = movie?.imdbID
        {
            omdbMovie.api.checkIfAnyTrailersAvailableStatusCodeWithString(id, completion: { (code) in
                if code == 34
                {
                    print("no trailers???????????")
                    self.trailerButtonOutlet.isHidden = true
                    self.trailerPic.isHidden = true
                    self.trailerLabel.isHidden = true
                }
                
            })
        }
    }
    
     func checkForData()
     {
        let userRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
     
        do{
            let object = try omdbMovie.managedObjectContext.fetch(userRequest)
            guard let movieObject = self.movie else {return}
            
            if object.count == 0
            {
                self.omdbMovie.getDetailsFor(movieObject)
                {
                    DispatchQueue.main.async(execute: {
                        self.releaseTemp.isHidden = false
                        self.dicrectorTemp.isHidden = false
                        self.writerTemp.isHidden = false
                        self.starsTemp.isHidden = false
                        self.metaTemp.isHidden = false
                        self.imdbTemp.isHidden = false
                        self.posterImage.isHidden = false
                        self.fullDescripTemp.isHidden = false
                        
                        self.moviePlotTextField.text = self.movie?.plot
                        self.releasedLabel.text = self.movie?.released
                        self.directorLabel.text = self.movie?.director
                        self.writerLabel.text = self.movie?.writer
                        self.starsLabel.text = self.movie?.actors
                        self.imbdScoreLabel.text = self.movie?.imdbRating
                        self.metaScoreLabel.text = self.movie?.metaScore
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        
                        self.imageDisplay()
                    })
                }
                
            }
    
            for movie in object
            {
                guard let savedMovieID = movie.movies?.first?.imdbID else {return}
                
               if object.count != 0 && savedMovieID == movieObject.imdbID
                {
                    self.releaseTemp.isHidden = false
                    self.dicrectorTemp.isHidden = false
                    self.writerTemp.isHidden = false
                    self.starsTemp.isHidden = false
                    self.metaTemp.isHidden = false
                    self.posterImage.isHidden = false
                    self.imdbTemp.isHidden = false
                    self.fullDescripTemp.isHidden = false
                    
                    self.moviePlotTextField.text = movie.movies?.first?.plot
                    self.releasedLabel.text = movie.movies?.first?.released
                    self.directorLabel.text = movie.movies?.first?.director
                    self.writerLabel.text = movie.movies?.first?.writer
                    self.starsLabel.text = movie.movies?.first?.actors
                    self.imbdScoreLabel.text = movie.movies?.first?.imdbRating
                    self.metaScoreLabel.text = movie.movies?.first?.metaScore
                    self.imageDisplay()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                else if savedMovieID != movieObject.imdbID
                {
                    self.omdbMovie.getDetailsFor(movieObject)
                    {
                        DispatchQueue.main.async(execute: {
                            self.releaseTemp.isHidden = false
                            self.dicrectorTemp.isHidden = false
                            self.writerTemp.isHidden = false
                            self.starsTemp.isHidden = false
                            self.metaTemp.isHidden = false
                            self.posterImage.isHidden = false
                            self.imdbTemp.isHidden = false
                            self.fullDescripTemp.isHidden = false
                            
                            self.moviePlotTextField.text = self.movie?.plot
                            self.releasedLabel.text = self.movie?.released
                            self.directorLabel.text = self.movie?.director
                            self.writerLabel.text = self.movie?.writer
                            self.starsLabel.text = self.movie?.actors
                            self.imbdScoreLabel.text = self.movie?.imdbRating
                            self.metaScoreLabel.text = self.movie?.metaScore
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.imageDisplay()
                            
                            })
                        }
                    }
                
                }
            
            }
            
            catch{print("Error")}
        
    }
    
    
    func imageDisplay()
    {
        let imageString = self.movie?.poster
        if let unwrappedString = imageString
        {
            let stringPosterUrl = URL(string: unwrappedString)
            if let url = stringPosterUrl
            {
                let dtinternet = try? Data(contentsOf: url)
                
                if let unwrappedImage = dtinternet
                {
                    self.posterImage.image = UIImage.init(data: unwrappedImage)
                    self.posterImageView.image = UIImage.init(data: unwrappedImage)
                    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
                    blurEffectView.frame = self.posterImageView.bounds
                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] 
                    
                    self.posterImageView.addSubview(blurEffectView)
                    
                }
            }
            
        }
    }
    

   
    @IBAction func trailerButton(_ sender: AnyObject)
    {
        print("pressed")
        
    }
    @IBAction func plotDescriptionButton(_ sender: AnyObject)
    {
        //segue
    }
    
    func saveMovie()
    {
        guard let savedMovieTitle = self.movie?.title else {return}
        
        let saveAlert = UIAlertController(title: "Saved",
                                      message: "\(savedMovieTitle) has been saved to favorites",
                                      preferredStyle: .alert)
        self.present(saveAlert, animated: true, completion: nil)
        self.navigationItem.rightBarButtonItem = nil

        DispatchQueue.main.async { () -> Void in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                saveAlert.dismiss(animated: true, completion: nil)
                
            })
        }
        
        let context = omdbMovie.managedObjectContext
    
        let addMovie = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context) as! Favorites
        
        guard let savedMovie = self.movie else {return}
        addMovie.movies?.insert(savedMovie)
        
        
        omdbMovie.saveContext()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "fullSummarySegue"
        {
            let destinationFullPlotVC = segue.destination as? FullPlotViewController
            
            if let unwrappedMovie = movie
            {
                destinationFullPlotVC?.movie = unwrappedMovie
            }
            
        }
        
        if segue.identifier == "movieSegue"
        {
            let destinationVC = segue.destination as? SearchedTrailerViewController
            
            if let unwrappedMovie = movie
            {
                destinationVC?.movieTrailer = unwrappedMovie
            }
        }
        
    }

}
