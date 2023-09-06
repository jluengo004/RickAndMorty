//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct Character: Decodable {
    var id: Int
    var name: String
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: NameWithURL?
    var location: NameWithURL?
    var image: URL?
    var episode: [URL]
    var url: URL?
    var created: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episode
        case url
        case created
    }
    
    init(id: Int, name: String, status: String? = nil,
         species: String? = nil, type: String? = nil,
         gender: String? = nil, origin: NameWithURL? = nil,
         location: NameWithURL? = nil, image: URL? = nil,
         episode: [URL] = [], url: URL? = nil, created: String? = nil) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(String?.self, forKey: .status)
        self.species = try container.decode(String?.self, forKey: .species)
        self.type = try container.decode(String?.self, forKey: .type)
        self.gender = try container.decode(String?.self, forKey: .gender)
        self.origin = try container.decode(NameWithURL?.self, forKey: .origin)
        self.location = try container.decode(NameWithURL?.self, forKey: .location)
        self.image = try container.decode(URL?.self, forKey: .image)
        self.episode = try container.decode([URL].self, forKey: .episode)
        self.url = try container.decode(URL?.self, forKey: .url)
        self.created = try container.decode(String?.self, forKey: .created)
    }
}

public struct NameWithURL: Decodable {
    var name: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String?.self, forKey: .name)
        self.url = try container.decode(String?.self, forKey: .url)
    }
}
