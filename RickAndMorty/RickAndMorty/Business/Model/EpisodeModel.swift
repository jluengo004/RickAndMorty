//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct Episode: Codable {
    var id: Int
    var name: String
    var episode: String?
    var characters: [URL]
    var url: URL?
    var created: String?
    var image: URL?
    var synopsis: String?
    
    public mutating func setCustomData(info: (String?, String?)) {
        self.image = URL(string: info.0 ?? "")
        self.synopsis = info.1
    }
}
