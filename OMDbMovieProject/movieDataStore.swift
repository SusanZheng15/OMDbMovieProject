////
////  movieDataStore.swift
////  OMDbMovieProject
////
////  Created by Flatiron School on 9/6/16.
////  Copyright © 2016 Flatiron School. All rights reserved.
////
//
//import Foundation
//
//class movieDataStore
//{
//    
//    static let sharedInstance = movieDataStore()
//    
//    private init() {}
//    
//    var data : [OMDBMovie] = []
//    
//    func getMoviesWithCompletion(completion: () -> ())
//    {
//        OMDbAPIClient.sharedInstance.OMDbSearchAPIcall("love") { (tempArray) in
//            
//            for movie in tempArray
//            {
//                let movieDict = OMDBMovie.init(dictionary: movie as! NSDictionary)
//                self.data.append(movieDict)
//            }
//            if self.data.count > 0
//            {
//                completion()
//            }
//        }
//        
////        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
////            self.repositories.removeAll()
////            for dictionary in reposArray
////            {
////                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in reposArray is of non-dictionary type") }
////                let repository = GithubRepository(dictionary: repoDictionary)
////                self.repositories.append(repository)
////                
////            }
////            completion()
////        }
//}