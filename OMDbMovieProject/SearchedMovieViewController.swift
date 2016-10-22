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
      
        moviesSearchBar.barStyle = UIBarStyle.blackTranslucent
        
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "customBackButton.png"), style: .done, target: self, action: #selector(SearchedMovieViewController.backButton))
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchedMovieViewController.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        self.tabBarController?.navigationItem.title = "Movie Search"
       
        self.noResultsLabel.isHidden = true
        self.searchActivityIndictor.isHidden = false
        self.searchActivityIndictor.startAnimating()
        self.title = "Movie Search"
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        internetReach = Reachability.forInternetConnection()
        internetReach?.startNotifier()
        
        self.statusChangedWithReachability(internetReach!)
        self.reachabilityImage.isHidden = true
    
    }
 
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = movieCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            //landscape
        } else {
            //portrait
        }
        
        flowLayout.invalidateLayout()
    }
    
    func backButton()
    {
        performSegue(withIdentifier: "backToUpcomingSegue", sender: self)
    }
    
    func backButtonPressed(sender:UIButton)
    {
        navigationController?.popViewController(animated: true)
    }


    func statusChangedWithReachability(_ currentStatus: Reachability)
    {
        let networkStatus: NetworkStatus = currentStatus.currentReachabilityStatus()
    
        print("Status: \(networkStatus.rawValue)")
        

        if networkStatus.rawValue == ReachableViaWiFi.rawValue
        {
            print("Reachable with Wifi")
            reachabilityStatus = kREACHABILITYWITHWIFI
            self.reachabilityImage.image = UIImage.init(named: "internetcheckMark.png")
            self.reachabilityImage.isHidden = false
            self.view.addSubview(self.reachabilityImage)
            self.view.bringSubview(toFront: self.reachabilityImage)
            
            UIView.animate(withDuration: 1.3, animations: {
                self.reachabilityImage.alpha = 0.0
                
            })
            
            let randomIndex = Int(arc4random_uniform(UInt32(randomSearchTerm.count)))
            let randomSearch = randomSearchTerm[randomIndex]
            
            self.store.getMovieRepositories(randomSearch) {
                OperationQueue.main.addOperation({
                    self.movieCollectionView.reloadData()
                    self.searchActivityIndictor.isHidden = true
                    self.searchActivityIndictor.stopAnimating()
                    
                })
            }
            moviesSearchBar.isUserInteractionEnabled = true
        }
        else if networkStatus.rawValue == ReachableViaWWAN.rawValue
        {
            print("Reachable with WWAN")
            reachabilityStatus = kREACHABLEWITHWWAN
            
            moviesSearchBar.isUserInteractionEnabled = true
            self.reachabilityImage.image = UIImage.init(named: "internetcheckMark.png")
            self.reachabilityImage.isHidden = false
            self.view.addSubview(self.reachabilityImage)
            self.view.bringSubview(toFront: self.reachabilityImage)
            
            UIView.animate(withDuration: 1.3, animations: {
                self.reachabilityImage.alpha = 0.0
                
            })
            
            let randomIndex = Int(arc4random_uniform(UInt32(randomSearchTerm.count)))
            let randomSearch = randomSearchTerm[randomIndex]
            self.store.getMovieRepositories(randomSearch) {
                OperationQueue.main.addOperation({
                    self.movieCollectionView.reloadData()
                    self.searchActivityIndictor.isHidden = true
                    self.searchActivityIndictor.stopAnimating()
                    
                })
            }
        }
        else if networkStatus.rawValue == NotReachable.rawValue
        {
            reachabilityStatus = kNOTREACHABLE
            print("Network not reachable")
            
            self.store.movieArray.removeAll()
            DispatchQueue.main.async(execute: {
                self.movieCollectionView.reloadData()
                self.searchActivityIndictor.isHidden = true
                self.searchActivityIndictor.stopAnimating()
                self.moviesSearchBar.isUserInteractionEnabled = false

            })
            
            let noNetworkAlertController = UIAlertController(title: "No Network Connection detected", message: "Cannot conduct search", preferredStyle: .alert)
            
            self.present(noNetworkAlertController, animated: true, completion: nil)
            
            DispatchQueue.main.async { () -> Void in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                    noNetworkAlertController.dismiss(animated: true, completion: nil)
                    self.view.bringSubview(toFront: self.reachabilityImage)
                    self.reachabilityImage.isHidden = false
                    self.reachabilityImage.alpha = 1.0
                    self.reachabilityImage.image = UIImage.init(named: "internetRedMark.png")
                    self.view.addSubview(self.reachabilityImage)
                })
            }
            
            
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reachStatusChanged"), object: nil)
    }
    
    
    func reachabilityChanged(_ notification: Notification)
    {
        print("Reachability status changed")
        reachability = notification.object as? Reachability
        self.statusChangedWithReachability(reachability!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemsCount : CGFloat = 2.0
        if UIApplication.shared.statusBarOrientation != UIInterfaceOrientation.portrait
        {
            itemsCount = 2.0
        }
        return CGSize(width: self.view.frame.width/itemsCount - 30, height: 240/120 * (self.view.frame.width/itemsCount - 30));
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.store.movieArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! SearchedMovieCollectionViewCell
     
        
        guard self.store.movieArray.count > 0 else { return cell }
        
        
            if let unwrappedPoster = self.store.movieArray[(indexPath as NSIndexPath).row].poster
            {
                if unwrappedPoster == "N/A"
                {
                    cell.moviePosterImageView.image = UIImage.init(named: "movieTempPic.png")
                }
            
                let stringPosterURL = URL(string: unwrappedPoster)
                
                if let url = stringPosterURL
                {
                    let dtinternet = try? Data(contentsOf: url)
                    
                    if let unwrappedImage = dtinternet
                    {
                        DispatchQueue.main.async(execute: {
                            cell.moviePosterImageView.image = UIImage.init(data: unwrappedImage)
                            cell.movieTitleLabel.text = self.store.movieArray[(indexPath as NSIndexPath).row].title
                            self.noResultsLabel.isHidden = true
                            self.searchActivityIndictor.isHidden = true
                            self.searchActivityIndictor.stopAnimating()
                        })
                    }
                }
            }
        
            return cell
        }
    
     //if bottom of collection view is reached, get more
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if (indexPath as NSIndexPath).row == self.store.movieArray.count - 1
        {

            if let searchText = moviesSearchBar.text
            {
                let search = searchText.replacingOccurrences(of: " ", with: "+").lowercased()
                
                if search == ""
                {
                    let randomIndex = Int(arc4random_uniform(UInt32(randomSearchTerm.count)))
                    let randomSearch = randomSearchTerm[randomIndex]
                    self.store.api.getNextPage()
                    self.store.getMovieRepositories(randomSearch, completion: {
                        DispatchQueue.main.async(execute: {
                            
                            self.movieCollectionView.reloadData()
                            print(self.store.movieArray.count)
                            
                        })
                        
                    })
                }
                else if search != ""
                {
                    self.store.api.getNextPage()
                    self.store.getMovieRepositories(search, completion: {
                        DispatchQueue.main.async(execute: {
                            
                            self.movieCollectionView.reloadData()
                            print(self.store.movieArray.count)
                            
                        })
                    })
                }

        }
    }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.moviesSearchBar.resignFirstResponder()
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        let searchResult = moviesSearchBar.text
        guard let unwrappedSearch = searchResult else {return}
        
        print(store.movieArray.count)

        if unwrappedSearch == ""
        {
            self.store.movieArray.removeAll()
           
            DispatchQueue.main.async(execute: {
                self.movieCollectionView.reloadData()
            })
        
        }
        else if unwrappedSearch != ""
        {
            self.store.movieArray.removeAll()
    
            let search = unwrappedSearch.replacingOccurrences(of: " ", with: "+").lowercased()
            self.store.api.pageNumber = 1
            self.store.getMovieRepositories(search, completion: {
                DispatchQueue.main.async(execute: {
                    self.movieCollectionView.reloadData()
                })
            })
            
        }
        if store.movieArray.count == 0
        {
            DispatchQueue.main.async(execute: {
                self.movieCollectionView.reloadData()
                self.noResultsLabel.isHidden = false
                self.view.addSubview(self.noResultsLabel)
                self.view.bringSubview(toFront: self.noResultsLabel)
                self.noResultsLabel.text = "No Results"
            })
        }        
        
    }
    
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.moviesSearchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "movieDetailSegue"
        {
            let destinationVC = segue.destination as! MovieDetailsViewController
            
            let indexPath = movieCollectionView.indexPath(for: sender as! UICollectionViewCell)
            
            if let unwrappedIndex = indexPath
            {
                let movie = self.store.movieArray[(unwrappedIndex as NSIndexPath).row]
                destinationVC.movie = movie
            }
            
        }
        
        
    }


}
