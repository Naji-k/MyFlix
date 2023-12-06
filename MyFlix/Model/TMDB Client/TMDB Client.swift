//
//  TMDB Client.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/22/23.
//

import Foundation

class TMDBClient {
    
//    Create a new request token
//    Get the user to authorize the request token
//    Create a new session id with the authorized request token
    
    static let apiKey = "bbaf9f6029e8bacc8d07c72fca003c32"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    static var profileInfo: ProfileResponse?
 
}
