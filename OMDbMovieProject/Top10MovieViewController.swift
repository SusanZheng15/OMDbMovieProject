//
//  Top10MovieViewController.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class Top10MovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var topMoviesCollectionView: UICollectionView!
    
    let store = MovieDataStore.sharedInstance
    var movie : Movie?
    
    let titleAndPic : [String : String] = ["goneWithTheWind.jpg": "Gone With the Wind", "Casablanca.jpg" : "Casablanca", "theWizardOfOz.jpg": "The Wizard of Oz","theGodfather.jpg": "The Godfather", "shawshankRedemption.jpg" : "The Shawshank Redemption", "toKillAMockingBird.jpg" : "To Kill a Mockingbird", "citizenKane.jpg" : "Citizen Kane", "vertigo.jpg":"Vertigo", "LawrenceOfArabia.jpg" : "Lawrence Of Arabia" ,  "psycho.jpg": "Psycho"]
    
    let topMoviePoster : [String] = ["goneWithTheWind.jpg", "Casablanca.jpg", "theWizardOfOz.jpg", "theGodfather.jpg", "shawshankRedemption.jpg", "toKillAMockingBird.jpg", "citizenKane.jpg", "vertigo.jpg", "LawrenceOfArabia.jpg", "psycho.jpg"]

    
    let topMoviesID : NSArray = ["tt0031381", "tt0034583", "tt0032138", "tt0068646", "tt0111161", "tt0056592", "tt0033467", "tt0052357", "tt0056172", "tt0054215"]

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        topMoviesCollectionView.delegate = self
        topMoviesCollectionView.dataSource = self
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
