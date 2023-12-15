//
//  LogoutRequest.swift
//  MyFlix
//
//  Created by Naji Kanounji on 12/14/23.
//

import Foundation

struct LogoutRequest: Codable {
    
    let session_id: String
    
    enum CodingKeys: String, CodingKey {
        case session_id
    }
}
