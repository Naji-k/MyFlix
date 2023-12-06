//
//  ProfileResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 12/5/23.
//

import Foundation

//profile has Avatar (not image) which can download it using https://www.gravatar.com/avatar/HASH

// MARK: - Profile
struct ProfileResponse: Codable {
    let avatar: Avatar
    let id: Int
    let iso639_1, iso3166_1, name: String
    let includeAdult: Bool
    let username: String

    enum CodingKeys: String, CodingKey {
        case avatar, id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
}

// MARK: - Avatar
struct Avatar: Codable {
    let gravatar: Gravatar
}

// MARK: - Gravatar
struct Gravatar: Codable {
    let hash: String
}
