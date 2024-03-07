//
//  NewsSourcesModel.swift
//

import Foundation

struct NewsSourcesModel: Codable {
    var id: String
    var name: String
    var language: String
    var country: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case language
        case country
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self , forKey: .id) ?? ""
        name = try values.decodeIfPresent(String.self , forKey: .name) ?? ""
        language = try values.decodeIfPresent(String.self , forKey: .language) ?? ""
        country = try values.decodeIfPresent(String.self , forKey: .country) ?? ""
    }
}

