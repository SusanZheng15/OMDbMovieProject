//
//  Favorites+CoreDataProperties.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/13/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorites
{
    @NSManaged var movies: Set<Movie>?
}
