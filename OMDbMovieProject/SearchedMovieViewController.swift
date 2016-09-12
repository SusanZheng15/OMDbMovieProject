//
//  SearchedMovieViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SearchedMovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate
{
    
    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var movie : Movie?
    
    let store = MovieDataStore.sharedInstance
     
    
    override func viewDidLoad()
    {
        moviesSearchBar.delegate = self
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        moviesSearchBar.showsCancelButton = true
        moviesSearchBar.barStyle = UIBarStyle.BlackTranslucent
        
        super.viewDidLoad()
        
        navBarUI()
        self.title = "Movie Search"
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.store.movieArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! SearchedMovieCollectionViewCell
        
        if self.store.movieArray[indexPath.row].poster == "N/A"
        {
            cell.moviePosterImageView.image = UIImage.init(named: "pikachu.png")
        }
        
//        self.movie?.convertPosterUrlToImage(self.store.movieArray[indexPath.row].poster, completion: { (success) in
//            if success
//            {
//                cell.moviePosterImageView.image = self.movie?.posterImage
//            }
//        })
        let stringPosterUrl = NSURL(string: self.store.movieArray[indexPath.row].poster)
        
        if let url = stringPosterUrl
        {
            let dtinternet = NSData(contentsOfURL: url)
            
            if let unwrappedImage = dtinternet
            {
                // TO DO: Needs to happen on the main queue
                 dispatch_async(dispatch_get_main_queue(),{
                    cell.moviePosterImageView.image = UIImage.init(data: unwrappedImage)
                    })
                
            }
            cell.movieTitleLabel.text = self.store.movieArray[indexPath.row].title
        }

    
        return cell

    }

    
    // if bottom of collection view is reached, get more
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height
        {
            
           if let searchText = moviesSearchBar.text
            {
                let search = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+").lowercaseString
                self.store.api.getNextPage()
                self.store.getMovieRepositories(search, completion: {
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.movieCollectionView.reloadData()
                        print(self.store.movieArray.count)
                        
                    })
                })
             
            }
            
            print("Reached the end of collection view")
            
        }
        
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.moviesSearchBar.resignFirstResponder()
    }

   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        let searchResult = moviesSearchBar.text
        guard let unwrappedSearch = searchResult else {return}
        
        print(store.movieArray.count)

        if unwrappedSearch.isEmpty == true
        {
            self.store.movieArray.removeAll()
           
            dispatch_async(dispatch_get_main_queue(),{
                self.movieCollectionView.reloadData()
            })
        
        }
        else
        {
            self.store.movieArray.removeAll()
            
            let search = unwrappedSearch.stringByReplacingOccurrencesOfString(" ", withString: "+").lowercaseString
            
            self.store.getMovieRepositories(search, completion: {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.movieCollectionView.reloadData()
                    })
                })
            
            
        }
        
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        self.moviesSearchBar.resignFirstResponder()
    }
    
    func navBarUI()
    {
        let navBarColor = navigationController!.navigationBar
        
        navBarColor.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(1.0)
      
        navBarColor.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Light", size: 25)!]
       
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Light", size: 19)!], forState: UIControlState.Normal)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "movieDetailSegue"
        {
            let destinationVC = segue.destinationViewController as! MovieDetailsViewController
            
            let indexPath = movieCollectionView.indexPathForCell(sender as! UICollectionViewCell)
            
            if let unwrappedIndex = indexPath
            {
                let movieID = self.store.movieArray[unwrappedIndex.row]
                destinationVC.movie = movieID
            }
            
        }
        
        
    }


}
