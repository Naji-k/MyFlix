//
//  UserListsResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 12/5/23.
//

import Foundation

struct UserListsResponse: Codable {
    let page: Int
    let results: [ListResponse]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ListResponse: Codable {
    let description: String
    let favoriteCount: Int
    let id: String
    let itemCount: Int
    let iso639_1, listType, name: String
    let posterPath: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case description
        case favoriteCount = "favorite_count"
        case id
        case itemCount = "item_count"
        case iso639_1 = "iso_639_1"
        case listType = "list_type"
        case name
        case posterPath = "poster_path"
    }
}
