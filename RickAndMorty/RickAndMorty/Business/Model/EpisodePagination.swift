//
//  EpisodePagination.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct EpisodePagination: Decodable {
    var info: PaginationInfo
    var results: [Episode]

    enum CodingKeys: String, CodingKey {
        case info
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.info = try container.decode(PaginationInfo.self, forKey: .info)
        self.results = try container.decode([Episode].self, forKey: .results)
    }
}
