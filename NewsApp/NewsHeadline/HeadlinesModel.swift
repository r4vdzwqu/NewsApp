//
//  HeadlinesModel.swift
//

import Foundation

struct HeadlinesModel: Codable {
    var title: String
    var description: String
    var newsLink: String
    var imageLink: String
    
    enum CodingKeys: String, CodingKey {
        case imageLink = "urlToImage"
        case newsLink = "url"
        case title
        case description
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self , forKey: .title) ?? ""
        description = try values.decodeIfPresent(String.self , forKey: .description) ?? ""
        newsLink = try values.decodeIfPresent(String.self , forKey: .newsLink) ?? ""
        imageLink = try values.decodeIfPresent(String.self , forKey: .imageLink) ?? ""
    }
}

struct SourcesModel: Codable {
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

