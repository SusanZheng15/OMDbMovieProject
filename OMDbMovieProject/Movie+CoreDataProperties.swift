//
//  Movie+CoreDataProperties.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/13/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie
{

    @NSManaged var title: String?
    @NSManaged var poster: String?
    @NSManaged var year: String?
    @NSManaged var imdbID: String?
    @NSManaged var released: String?
    @NSManaged var plot: String?
    @NSManaged var director: String?
    @NSManaged var writer: String?
    @NSManaged var actors: String?
    @NSManaged var imdbRating: String?
    @NSManaged var metaScore: String?
    @NSManaged var fullSummary: String?


}
