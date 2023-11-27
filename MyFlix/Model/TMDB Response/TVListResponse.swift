//
//  TVListResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/27/23.
//

import Foundation

struct TVListResponse: Codable {
    let page: Int
    let results: [TVResponse]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
