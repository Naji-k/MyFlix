//
//  ActorDetailResponse.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/27/23.
//

import Foundation

struct ActorDetailResponse: Codable {
    
    let adult: Bool
    let alsoKnowsAs: [String]
    let biography: String
    let birthday: String
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdb_id: String
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String
    let popularity: Double
    let profilePath: String?
    
    
    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnowsAs = "also_known_as"
        case biography
        case birthday
        case deathday
        case gender
        case homepage
        case id
        case imdb_id
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
    
    func calAge(birthday: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let birthdateDate = dateFormatter.date(from: birthday)
        
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: birthdateDate!, to: Date())
        return (String(dateComponent.year!))
        
    }
}


