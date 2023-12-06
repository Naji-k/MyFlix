//
//  LoginRequest.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/28/23.
//

import Foundation

struct LoginRequest: Codable {
    
    let userName: String
    let password: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case password = "password"
        case requestToken = "request_token"
    }
    
}
