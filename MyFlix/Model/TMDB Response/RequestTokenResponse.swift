//
//  RequestTokenResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/28/23.
//

import Foundation

struct RequestTokenResponse: Codable {
    
      let success : Bool
      let expiresAt : String
      let requestToken : String
 
    enum CodingKeys: String, CodingKey {
        
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
          
    }
}
