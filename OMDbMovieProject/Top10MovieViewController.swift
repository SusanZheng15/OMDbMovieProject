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
 
    override func viewDidLoad()
    {
        super.viewDidLoad()

    
        topMoviesCollectionView.delegate = self
        topMoviesCollectionView.dataSource = self
        
        self.startSearchButton.layer.borderWidth = 1
        self.startSearchButton.layer.borderColor = UIColor.greenColor().CGColor
        self.startSearchButton.layer.cornerRadius = 10
        self.startSearchButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        store.api.getMoviesPlayingInTheaters { (array) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.topMoviesCollectionView.reloadData()
            })
            
        }
       
        
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
        return CGSize(width: self.view.frame.width/itemsCount, height: 100/62.5 * (self.view.frame.width/itemsCount));
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return store.api.upcomingMovie.count
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TopMoviesCollectionViewCell

        
        let stringPosterURL = NSURL(string: "http://image.tmdb.org/t/p/w500"+store.api.upcomingMovie[indexPath.row].poster)
        
        if let url = stringPosterURL
        {
            let dtinternet = NSData(contentsOfURL: url)
            
            if let unwrappedImage = dtinternet
            {
                dispatch_async(dispatch_get_main_queue(),{
                    cell.topMoviesImageView.image = UIImage.init(data: unwrappedImage)
                })
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(store.api.upcomingMovie[indexPath.row].id)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "movieTrailerSegue"
        {
            let destinationVC = segue.destinationViewController as! MovieTrailerViewController
            
            let indexPath = topMoviesCollectionView.indexPathForCell(sender as! UICollectionViewCell)
            
            if let unwrappedIndex = indexPath
            {
                let id = self.store.api.upcomingMovie[unwrappedIndex.row].id
                print(id)
                destinationVC.movieID = id
            }
            
        }
    }
    

}
