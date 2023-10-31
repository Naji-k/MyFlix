//
//  SessionRequest.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/28/23.
//

import Foundation
//create SessionId PostRequest
struct SessionRequest: Codable {
    
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}
