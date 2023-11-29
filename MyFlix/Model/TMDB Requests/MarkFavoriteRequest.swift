//
//  MarkFavorite.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/28/23.
//

import Foundation

struct MarkFavoriteRequest: Codable {
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaId = "media_id"
        case favorite
    }
}
