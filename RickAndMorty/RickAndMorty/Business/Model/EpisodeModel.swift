//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct Episode: Decodable {
    var id: Int
    var name: String
    var airDate: String?
    var episode: String?
    var characters: [String]
    var url: URL?
    var created: String?
    var image: URL?
    var synopsis: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
        case created
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.airDate = try container.decode(String?.self, forKey: .airDate)
        self.episode = try container.decode(String?.self, forKey: .episode)
        self.characters = try container.decode([String].self, forKey: .characters)
        self.url = try container.decode(URL?.self, forKey: .url)
        self.created = try container.decode(String?.self, forKey: .created)
    }
    
    public mutating func setCustomData(info: (String?, String?)) {
        self.image = URL(string: info.0 ?? "")
        self.synopsis = info.1
    }
}
