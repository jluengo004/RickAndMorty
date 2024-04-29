//
//  CharactersPagination.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct CharacterPagination: Codable {
    let info: PaginationInfo
    let results: [Character]
}
