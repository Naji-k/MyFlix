//
//  MovieData.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/1/23.
//

import Foundation

class MovieData {
    static var userLists = [ListResponse]()
    
    static var favList = [MultiTypeMediaResponse]()
    static var favTVList = [MultiTypeMediaResponse]()
    static var movieWatchList = [MultiTypeMediaResponse]()
    static var tvWatchList = [MultiTypeMediaResponse]()
    
    //for MovieMainVC
    static var movieNowPlaying = [MultiTypeMediaResponse]() // get this from discover by filter
    static var movieMostPopular = [MultiTypeMediaResponse]() //get this from discover by filter
    static var movieTopRated = [MultiTypeMediaResponse]() //get this from discover by filter
    //TV MainCall
    static var TVPopular = [MultiTypeMediaResponse]()
    static var TVTopRated = [MultiTypeMediaResponse]()
    static var TVOnTheAir = [MultiTypeMediaResponse]()
    
}

enum mediaCategory {
    case movie
    case tv
    case person
    
    var stringValue: String {
        
        switch self {
        case .movie : return "movie"
        case .tv : return "tv"
        case .person : return "person"
        }
    }
}

enum ListType {
    case favorite
    case watch
    
    var stringValue: String {
        
        switch self {
        case .favorite : return "favorite"
        case .watch : return "watchlist"
        }
    }
}
