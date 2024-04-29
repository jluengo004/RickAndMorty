//
//  PaginationInfo.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct PaginationInfo: Codable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}
