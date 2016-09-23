//
//  Top10MovieViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class Top10MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var topMoviesCollectionView: UICollectionView!
    
    @IBOutlet weak var startSearchButton: UIButton!
    
    let store = MovieDataStore.sharedInstance
    var movie : Movie?
    var movieList = ""
    
    let titleAndPic : [String : String] = ["goneWithTheWind.jpg": "Gone With the Wind", "Casablanca.jpg" : "Casablanca", "theWizardOfOz.jpg": "The Wizard of Oz","theGodfather.jpg": "The Godfather", "shawshankRedemption.jpg" : "The Shawshank Redemption", "toKillAMockingBird.jpg" : "To Kill a Mockingbird", "citizenKane.jpg" : "Citizen Kane", "vertigo.jpg":"Vertigo", "LawrenceOfArabia.jpg" : "Lawrence Of Arabia" ,  "psycho.jpg": "Psycho"]
    
    let topMoviePoster : [String] = ["goneWithTheWind.jpg", "Casablanca.jpg", "theWizardOfOz.jpg", "theGodfather.jpg", "shawshankRedemption.jpg", "toKillAMockingBird.jpg", "citizenKane.jpg", "vertigo.jpg", "lawrenceOfArabia.jpg", "psycho.jpg"]

    
    let topMoviesID : NSArray = ["tt0031381", "tt0034583", "tt0032138", "tt0068646", "tt0111161", "tt0056592", "tt0033467", "tt0052357", "tt0056172", "tt0054215"]

    let dictionary : [String:[String]] = ["topMovies" : ["Gone+With+the+Wind", "Casablanca", "The+Wizard of+Oz", "The+Godfather", "The+Shawshank+Redemption", "To+Kill+a+Mockingbird", "Citizen+Kane", "Vertigo", "Lawrence+Of+Arabia", "Psycho"]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    
        topMoviesCollectionView.delegate = self
        topMoviesCollectionView.dataSource = self
        
        self.startSearchButton.layer.borderWidth = 1
        self.startSearchButton.layer.borderColor = UIColor.greenColor().CGColor
        self.startSearchButton.layer.cornerRadius = 10
        self.startSearchButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = topMoviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else
        {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
        {
            //landscape
        } else {
            //portrait
        }
        
        flowLayout.invalidateLayout()
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var itemsCount : CGFloat = 1.0
        if UIApplication.sharedApplication().statusBarOrientation != UIInterfaceOrientation.Portrait
        {
            itemsCount = 1.0
        }
        return CGSize(width: self.view.frame.width/itemsCount - 20, height: 100/66 * (self.view.frame.width/itemsCount - 20));
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.titleAndPic.count
    }
    
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TopMoviesCollectionViewCell
        
        let movieImage = topMoviePoster[indexPath.row]
      
        cell.topMoviesImageView.image = UIImage.init(named: movieImage)
        cell.topMoviesLabel.text = titleAndPic[movieImage]
    
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let path = topMoviesID[indexPath.row]
        print(path)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        if segue.identifier == "topMovieSegue"
//        {
//            let destinationVC = segue.destinationViewController as! MovieDetailsViewController
//            let indexPath = topMoviesCollectionView.indexPathForCell(sender as! UICollectionViewCell)
//            let id = topMoviesID[indexPath!.row] as? String
//            if let unwrappedID = id
//            {
//                destinationVC.movieID = unwrappedID
//            }
//            
//        }
//    }
    

}
