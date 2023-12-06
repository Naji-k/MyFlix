//
//  MovieListResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/1/23.
//

import Foundation

struct MovieListResponse: Codable {
    
    let page: Int
    let results: [MovieResponse]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}

//for MultiTypeMedia (used for generics VC) it will receive the results and combine between Movie-TV-Person
struct MultiTypeMediaListResponse: Codable {
    
    let page: Int
    let results: [MultiTypeMediaResponse]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}
