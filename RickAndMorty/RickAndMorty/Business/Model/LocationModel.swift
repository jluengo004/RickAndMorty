//
//  LocationModel.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct Location: Decodable {
    var id: Int
    var name: String
    var type: String?
    var dimension: String?
    var residents: [String]
    var url: URL?
    var created: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case dimension
        case residents
        case url
        case created
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String?.self, forKey: .type)
        self.dimension = try container.decode(String?.self, forKey: .dimension)
        self.residents = try container.decode([String].self, forKey: .residents)
        self.url = try container.decode(URL?.self, forKey: .url)
        self.created = try container.decode(String?.self, forKey: .created)
    }
}
