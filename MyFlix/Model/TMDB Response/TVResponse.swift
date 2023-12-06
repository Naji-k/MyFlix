//
//  TVResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/27/23.
//

import Foundation

struct TVResponse: Codable {
    
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originCountry: [OriginCountry]
    let originalLanguage: OriginalLanguage
    let original_title, overview: String
    let popularity: Double
    let posterPath: String?
    let firstAirDate, name: String
    let voteAverage: Double
    let voteCount: Int
    
    //to return Only release year
    var releaseYear: String {
        return String(firstAirDate.prefix(4))
    }
    
    var idString: String {
        return String(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case original_title = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
}

enum OriginCountry: String, Codable {
    case us = "US"
}

enum OriginalLanguage: String, Codable {
    case en = "en"
}
