//
//  PaginationInfo.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct PaginationInfo: Decodable {
    var count: Int
    var pages: Int
    var next: URL
    var prev: URL?

    enum CodingKeys: String, CodingKey {
        case count
        case pages
        case next
        case prev
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.pages = try container.decode(Int.self, forKey: .pages)
        self.next = try container.decode(URL.self, forKey: .next)
        self.prev = try container.decode(URL?.self, forKey: .prev)
    }
}
