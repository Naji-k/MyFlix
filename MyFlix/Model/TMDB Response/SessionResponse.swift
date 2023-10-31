//
//  SessionResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/31/23.
//

import Foundation

struct SessionResponse: Codable {
    
    let success: Bool
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
}
