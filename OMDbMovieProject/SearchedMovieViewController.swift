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
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var movie : Movie?
    
    let store = MovieDataStore.sharedInstance
    
    deinit{
        print("Im dead")
    }
     
    
    override func viewDidLoad()
    {
        moviesSearchBar.delegate = self
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        moviesSearchBar.barStyle = UIBarStyle.BlackTranslucent
        
        
        super.viewDidLoad()
        
        navBarUI()
        
        self.title = "Movie Search"
        noInternetConnectionAlert()
        print(store.movieArray.count)
    
    }

    
    func noInternetConnectionAlert()
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            noResultsLabel.hidden = true
            self.store.getMovieRepositories("who") {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.movieCollectionView.reloadData()
                })
            }
        }
        else
        {
            let noInternetAlertController = UIAlertController(title: "No Wifi Connection detected", message: "Cannot conduct search", preferredStyle: .Alert)
            noInternetAlertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(noInternetAlertController, animated: true, completion: nil)
            self.noResultsLabel.text = "No Wifi Connection"
          
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.store.movieArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! SearchedMovieCollectionViewCell
        
        guard self.store.movieArray.count > 0 else { return cell }
        
        
            if let unwrappedPoster = self.store.movieArray[indexPath.row].poster
            {
                if unwrappedPoster == "N/A"
                {
                    cell.moviePosterImageView.image = UIImage.init(named: "pikachu.png")
                }
            
                let stringPosterURL = NSURL(string: unwrappedPoster)
                
                if let url = stringPosterURL
                {
                    let dtinternet = NSData(contentsOfURL: url)
                    
                    if let unwrappedImage = dtinternet
                    {
                        dispatch_async(dispatch_get_main_queue(),{
                            cell.moviePosterImageView.image = UIImage.init(data: unwrappedImage)
                            cell.movieTitleLabel.text = self.store.movieArray[indexPath.row].title
                            self.noResultsLabel.hidden = true
                        })
                    }
                }
            }
        
            return cell
        }


    
     //if bottom of collection view is reached, get more
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height
        {
            
           if let searchText = moviesSearchBar.text
           {
                let search = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+").lowercaseString
            
            if search == ""
            {
                self.store.api.getNextPage()
                self.store.getMovieRepositories("who", completion: {
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.movieCollectionView.reloadData()
                        print(self.store.movieArray.count)
                        
                    })

                })
            }
            else if search != ""
            {
                self.store.api.getNextPage()
                self.store.getMovieRepositories(search, completion: {
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.movieCollectionView.reloadData()
                        print(self.store.movieArray.count)
                        
                    })
                })
            }
            
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
    

        if unwrappedSearch == ""
        {
            self.store.movieArray.removeAll()
           
            dispatch_async(dispatch_get_main_queue(),{
                self.movieCollectionView.reloadData()
            })
        
        }
        else if unwrappedSearch != ""
        {
            self.store.movieArray.removeAll()
    
            let search = unwrappedSearch.stringByReplacingOccurrencesOfString(" ", withString: "+").lowercaseString
            self.store.api.pageNumber = 1
            self.store.getMovieRepositories(search, completion: {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.movieCollectionView.reloadData()
                    })
                })
            
            
        }
        if store.movieArray.count == 0
        {
            dispatch_async(dispatch_get_main_queue(),{
                self.movieCollectionView.reloadData()
                self.noResultsLabel.hidden = false
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
        
        navBarColor.backgroundColor = UIColor.blueColor()
        navBarColor.alpha = 1.0
      
        navBarColor.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Bold", size: 20)!]
    
        
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
