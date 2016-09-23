//
//  SearchedMovieViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

let kREACHABILITYWITHWIFI = "ReachableWithWIFI"
let kNOTREACHABLE = "notReachable"
let kREACHABLEWITHWWAN = "ReachableWithWWAN"

 var reachability: Reachability?
 var reachabilityStatus = kREACHABILITYWITHWIFI

class SearchedMovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var reachabilityImage: UIImageView!
    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var searchActivityIndictor: UIActivityIndicatorView!
    
    var movie : Movie?
    var internetReach: Reachability?
    let randomSearchTerm = ["love", "horror", "game", "the", "night", "life", "west", "wild", "star", "adventure", "heart", "who", "gone", "kill"]
    

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
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchedMovieViewController.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
        
        self.tabBarController?.navigationItem.title = "Movie Search"
       
        self.noResultsLabel.hidden = true
        self.searchActivityIndictor.hidden = false
        self.searchActivityIndictor.startAnimating()
        self.title = "Movie Search"
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        internetReach = Reachability.reachabilityForInternetConnection()
        internetReach?.startNotifier()
        
        self.statusChangedWithReachability(internetReach!)
        self.reachabilityImage.hidden = true
    
    }
 
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = movieCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            //landscape
        } else {
            //portrait
        }
        
        flowLayout.invalidateLayout()
    }
  
    func statusChangedWithReachability(currentStatus: Reachability)
    {
        let networkStatus: NetworkStatus = currentStatus.currentReachabilityStatus()
    
        print("Status: \(networkStatus.rawValue)")
        

        if networkStatus.rawValue == ReachableViaWiFi.rawValue
        {
            print("Reachable with Wifi")
            reachabilityStatus = kREACHABILITYWITHWIFI
            self.reachabilityImage.image = UIImage.init(named: "internetcheckMark.png")
            self.reachabilityImage.hidden = false
            self.view.addSubview(self.reachabilityImage)
            self.view.bringSubviewToFront(self.reachabilityImage)
            
            UIView.animateWithDuration(1.3, animations: {
                self.reachabilityImage.alpha = 0.0
                
            })
            
            let randomIndex = Int(arc4random_uniform(UInt32(randomSearchTerm.count)))
            let randomSearch = randomSearchTerm[randomIndex]
            
            self.store.getMovieRepositories(randomSearch) {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.movieCollectionView.reloadData()
                    self.searchActivityIndictor.hidden = true
                    self.searchActivityIndictor.stopAnimating()
                    
                })
            }
            moviesSearchBar.userInteractionEnabled = true
        }
        else if networkStatus.rawValue == ReachableViaWWAN.rawValue
        {
            print("Reachable with WWAN")
            reachabilityStatus = kREACHABLEWITHWWAN
            
            moviesSearchBar.userInteractionEnabled = true
            self.reachabilityImage.image = UIImage.init(named: "internetcheckMark.png")
            self.reachabilityImage.hidden = false
            self.view.addSubview(self.reachabilityImage)
            self.view.bringSubviewToFront(self.reachabilityImage)
            
            UIView.animateWithDuration(1.3, animations: {
                self.reachabilityImage.alpha = 0.0
                
            })
            let randomIndex = Int(arc4random_uniform(UInt32(randomSearchTerm.count)))
            let randomSearch = randomSearchTerm[randomIndex]
            self.store.getMovieRepositories(randomSearch) {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.movieCollectionView.reloadData()
                    self.searchActivityIndictor.hidden = true
                    self.searchActivityIndictor.stopAnimating()
                    
                })
            }
        }
        else if networkStatus.rawValue == NotReachable.rawValue
        {
            reachabilityStatus = kNOTREACHABLE
            print("Network not reachable")
            
            self.store.movieArray.removeAll()
            dispatch_async(dispatch_get_main_queue(),{
                self.movieCollectionView.reloadData()
                self.searchActivityIndictor.hidden = true
                self.searchActivityIndictor.stopAnimating()
                self.moviesSearchBar.userInteractionEnabled = false

            })
            
            let noNetworkAlertController = UIAlertController(title: "No Network Connection detected", message: "Cannot conduct search", preferredStyle: .Alert)
            
            self.presentViewController(noNetworkAlertController, animated: true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    noNetworkAlertController.dismissViewControllerAnimated(true, completion: nil)
                    self.view.bringSubviewToFront(self.reachabilityImage)
                    self.reachabilityImage.hidden = false
                    self.reachabilityImage.alpha = 1.0
                    self.reachabilityImage.image = UIImage.init(named: "internetRedMark.png")
                    self.view.addSubview(self.reachabilityImage)
                })
            }
            
            
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("reachStatusChanged", object: nil)
    }
    
    
    func reachabilityChanged(notification: NSNotification)
    {
        print("Reachability status changed")
        reachability = notification.object as? Reachability
        self.statusChangedWithReachability(reachability!)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var itemsCount : CGFloat = 2.0
        if UIApplication.sharedApplication().statusBarOrientation != UIInterfaceOrientation.Portrait
        {
            itemsCount = 3.0
        }
        return CGSize(width: self.view.frame.width/itemsCount - 40, height: 240/100 * (self.view.frame.width/itemsCount - 40));
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
                let randomIndex = Int(arc4random_uniform(UInt32(randomSearchTerm.count)))
                let randomSearch = randomSearchTerm[randomIndex]
                self.store.api.getNextPage()
                self.store.getMovieRepositories(randomSearch, completion: {
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
                self.view.addSubview(self.noResultsLabel)
                self.view.bringSubviewToFront(self.noResultsLabel)
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
                let movie = self.store.movieArray[unwrappedIndex.row]
                destinationVC.movie = movie
            }
            
        }
        
        
    }


}
