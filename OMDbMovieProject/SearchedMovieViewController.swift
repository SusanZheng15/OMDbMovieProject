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
    
    @IBOutlet weak var searchActivityIndictor: UIActivityIndicatorView!
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
      
        moviesSearchBar.barStyle = UIBarStyle.BlackTranslucent
        
        
        super.viewDidLoad()
        
      
        
        self.tabBarController?.navigationItem.title = "Movie Search"
        self.searchActivityIndictor.hidden = false
        self.searchActivityIndictor.startAnimating()
        self.title = "Movie Search"
        noInternetConnectionAlert()
       
        
        
    
    }
    
    override func viewWillAppear(animated: Bool)
    {
        noInternetConnectionAlert()
    }
    
  //  override func view
    
    func noInternetConnectionAlert()
    {
        
        if Reachability.isConnectedToNetwork() == true
        {
            self.store.getMovieRepositories("who") {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.movieCollectionView.reloadData()
                    self.searchActivityIndictor.hidden = true
                    self.searchActivityIndictor.stopAnimating()
                })
            }

            moviesSearchBar.userInteractionEnabled = true
        }
        else
        {
            let noInternetAlertController = UIAlertController(title: "No Wifi Connection detected", message: "Cannot conduct search", preferredStyle: .Alert)
            
            self.presentViewController(noInternetAlertController, animated: true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    noInternetAlertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
            self.noResultsLabel.text = "No Wifi Connection"
            moviesSearchBar.userInteractionEnabled = false
    
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
                            self.searchActivityIndictor.hidden = true
                            self.searchActivityIndictor.stopAnimating()
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
                self.noResultsLabel.text = "No Results"
            })
        }        
        
    }
 
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        self.moviesSearchBar.resignFirstResponder()
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
