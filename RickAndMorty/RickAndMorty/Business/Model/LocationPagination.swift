//
//  LocationPagination.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct LocationPagination: Decodable {
    var info: PaginationInfo
    var results: [Location]

    enum CodingKeys: String, CodingKey {
        case info
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.info = try container.decode(PaginationInfo.self, forKey: .info)
        self.results = try container.decode([Location].self, forKey: .results)
    }
}
