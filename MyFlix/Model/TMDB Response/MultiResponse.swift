//
//  MultiResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/28/23.
//

import Foundation

// MARK: - Multi

struct MultiTypeMediaResponse: Codable {
    
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let name, originalLanguage, originalName, overview: String?
    let posterPath: String?
    let mediaType: String?
    let genreIDS: [Int]?
    let popularity: Double
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?
    let originCountry: [String]?
    let title, originalTitle, releaseDate: String?
    let video: Bool?
    let gender: Int?
    let knownForDepartment: String?
    let profilePath: JSONNull?
    let knownFor: [KnownFor]?

    var idString: String {
        return String(id)
    }
    
    var releaseYear: String {
        if let releaseDate = releaseDate {
            return (String(releaseDate.prefix(4)))
        } else if let releaseDate = firstAirDate{
            return (String(releaseDate.prefix(4)))
        }
        return ""
    }

    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
        case title
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case video, gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

// MARK: - KnownFor
struct KnownFor: Codable {
    let adult: Bool
    let backdropPath: JSONNull?
    let id: Int
    let title, originalLanguage, originalTitle, overview: String
    let posterPath: JSONNull?
    let mediaType: String?
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage, voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
