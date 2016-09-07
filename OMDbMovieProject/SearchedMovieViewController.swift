//
//  SearchedMovieViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SearchedMovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    @IBOutlet weak var movieCollectionView: UICollectionView!


    var omdbMovie = OMDbAPIClient.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        omdbMovie.OMDbSearchAPIcall("love") { (array) in
            
            dispatch_async(dispatch_get_main_queue(),{
                self.movieCollectionView.reloadData()
            })
            
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.omdbMovie.movieArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! SearchedMovieCollectionViewCell
        
        cell.movieTitleLabel.text = self.omdbMovie.movieArray[indexPath.row].title
        
        let stringUrl = NSURL(string: self.omdbMovie.movieArray[indexPath.row].poster)
        
        if let url = stringUrl
        {
            let dtinternet = NSData(contentsOfURL: url)
            
            if let unwrappedImage = dtinternet
            {
                cell.moviePosterImageView.image = UIImage.init(data: unwrappedImage)
            }
        }
        
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("did selected")
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
