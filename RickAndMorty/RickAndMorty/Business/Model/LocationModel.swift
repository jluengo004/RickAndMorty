//
//  LocationModel.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public struct Location: Codable {
    let id: Int
    let name: String
    let type: String?
    let dimension: String?
    let residents: [String]
    let url: URL?
    let created: String?
}
