//
//  Movie.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/1/23.
//

import Foundation

struct MovieResponse: Codable, Equatable {
    
    let adult: Bool
    let backdropPath: String?
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    //to return Only release year
    var releaseYear: String {
        return String(release_date.prefix(4))
    }
    
    var idString: String {
        return String(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genre_ids = "genre_ids"
        case id = "id"
        case original_language = "original_language"
        case original_title = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case release_date = "release_date"
        case title = "title"
        case video = "video"
        case vote_average = "vote_average"
        case vote_count = "vote_count"

    }

}
