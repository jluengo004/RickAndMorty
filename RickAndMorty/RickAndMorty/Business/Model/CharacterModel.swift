//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct Character: Codable {
    let id: Int
    let name: String
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin: NameWithURL?
    let location: NameWithURL?
    let image: URL?
    let episode: [URL]
    let url: URL?
    let created: String?
    
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
}

public struct NameWithURL: Codable {
    let name: String?
    let url: String?
}
