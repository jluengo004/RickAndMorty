//
//  JSONHelper.swift
//  RickAndMortyTests
//
//  Created by Jon Luengo on 7/9/23.
//

import Foundation

class JSONHelper {
    func getJSONObject(bundle: Bundle, for jsonName: String) throws -> [String:Any]? {
        guard let json = try getJSON(bundle: bundle, for: jsonName)
        else { return nil }
        return json
    }

    func getJSON(bundle: Bundle, for jsonName: String) throws -> [String:Any]? {
        guard let path = bundle.path(forResource: jsonName, ofType: "json") else {
            fatalError("Could not retrieve file \(jsonName).json")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
    }
    
    func getData(bundle: Bundle, for jsonName: String) throws -> Data? {
        guard let path = bundle.path(forResource: jsonName, ofType: "json") else {
            fatalError("Could not retrieve file \(jsonName).json")
        }
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
}
