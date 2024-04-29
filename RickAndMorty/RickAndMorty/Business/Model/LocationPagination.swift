//
//  LocationPagination.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct LocationPagination: Codable {
    let info: PaginationInfo
    let results: [Location]
}
