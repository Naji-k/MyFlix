//
//  TMDBResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/28/23.
//

import Foundation

//general TMDBResponse for AddFav, AddWatchList...

struct TMDBResponse: Codable {
    
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
