//
//  CharacterService.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation
import UIKit

public enum CharacterStatus: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unkonwn"
}

public enum CharacterGender: String {
    case female = "female"
    case male = "male"
    case genderless = "genderless"
    case unknown = "unkonwn"
}

public class CharacterFilterParams: Equatable {
    var ids: [String]?
    var name: String?
    var status: CharacterStatus?
    var species: String?
    var type: String?
    var gender: CharacterGender?
    
    public init(ids: [String]?, name: String?, status: CharacterStatus?, species: String?, type: String?, gender: CharacterGender?) {
        self.ids = ids
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
    }
    
    public static func == (lhs: CharacterFilterParams, rhs: CharacterFilterParams) -> Bool {
        return (lhs.ids == rhs.ids &&
                lhs.name == rhs.name &&
                lhs.status == rhs.status &&
                lhs.species == rhs.species &&
                lhs.type == rhs.type &&
                lhs.gender == rhs.gender)
    }
    
    func getQueryFilterParams(page: Int) -> [URLQueryItem] {
        var queryParams: [URLQueryItem] = []
        queryParams.append(URLQueryItem(name: "page", value: String(page)))
        if let name = name, !name.isEmpty {
            queryParams.append(URLQueryItem(name: "name", value: name))
        }
        if let status = status {
            queryParams.append(URLQueryItem(name: "status", value: status.rawValue))
        }
        if let species = species, !species.isEmpty {
            queryParams.append(URLQueryItem(name: "species", value: species))
        }
        if let type = type, !type.isEmpty {
            queryParams.append(URLQueryItem(name: "type", value: type))
        }
        if let gender = gender {
            queryParams.append(URLQueryItem(name: "gender", value: gender.rawValue))
        }
        
        return queryParams
    }
    
    func getLabelFilterParams() -> NSMutableAttributedString {
        var filterAttributedString = NSMutableAttributedString(string: "")
        if let name = name, !name.isEmpty {
            concatenateBoldAndValueString(mainString: &filterAttributedString, title: "Name", value: name)
        }
        if let status = status {
            concatenateBoldAndValueString(mainString: &filterAttributedString, title: "Status", value: status.rawValue)
        }
        if let species = species, !species.isEmpty {
            concatenateBoldAndValueString(mainString: &filterAttributedString, title: "Species", value: species)
        }
        if let type = type, !type.isEmpty {
            concatenateBoldAndValueString(mainString: &filterAttributedString, title: "Type", value: type)
        }
        if let gender = gender {
            concatenateBoldAndValueString(mainString: &filterAttributedString, title: "Gender", value: gender.rawValue)
        }
        
        return filterAttributedString
    }
    
    private func concatenateBoldAndValueString(mainString: inout NSMutableAttributedString, title: String, value: String) {
        let boldAttribute = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]
        let titleBoldAttributedString = NSMutableAttributedString(string: "\(title): ", attributes: boldAttribute)
        let valueAttributedString = NSMutableAttributedString(string: "\(value)  ")
        mainString.append(titleBoldAttributedString)
        mainString.append(valueAttributedString)
    }
    
    func getCharactersIDParams() -> String {
        var paramsString = "/"
        var isFirstCharacter = true
        if let ids = ids {
            for id in ids {
                paramsString += isFirstCharacter ? "" : ","
                paramsString += id
                isFirstCharacter = false
            }
        }
        return paramsString
    }
}

public class CharacterService {
    
    private let baseURL = "https://rickandmortyapi.com/api/character/"
    private let networkManager = NetworkManager()
    
    public func getAllCharacters(completion: @escaping (RMResult<CharacterPagination, String>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(RMResult.failure("url error"))
            return
        }
        startCharacterPaginationNetworkCall(url: url) { result in
            completion(result)
        }
    }
    
    public func getCharacterPage(page: Int, completion: @escaping (RMResult<CharacterPagination, String>) -> Void) {
        guard let url = URL(string: baseURL + "?page=\(page)") else {
            completion(RMResult.failure("url error"))
            return
        }
        startCharacterPaginationNetworkCall(url: url) { result in
            completion(result)
        }
    }
    
    public func getFilteredCharacters(params: CharacterFilterParams, page: Int, completion: @escaping (RMResult<CharacterPagination, String>) -> Void) {
        var urlComps = URLComponents(string: baseURL)
        urlComps?.queryItems = params.getQueryFilterParams(page: page)
        guard let url = urlComps?.url else {
            completion(RMResult.failure("param error"))
            return
        }
        startCharacterPaginationNetworkCall(url: url) { result in
            completion(result)
        }
    }
    
    public func getCharactersByID(params: CharacterFilterParams, completion: @escaping (RMResult<[Character], String>) -> Void) {
        guard let url = URL(string: baseURL + params.getCharactersIDParams()) else {
            completion(RMResult.failure("url error"))
            return
        }
        startCharactersNetworkCall(url: url) { result in
            completion(result)
        }
    }
    
    
    private func startCharactersNetworkCall(url: URL, completion: @escaping (RMResult<[Character], String>) -> Void) {
        networkManager.httpGet(url: url) { result in
            switch result {
            case .success(let charactersData):
                if let characters = try? JSONDecoder().decode([Character].self, from: charactersData) {
                    let charactersResult = RMResult<[Character], String>.success(characters)
                    completion(charactersResult)
                } else {
                    let codingError = RMResult<[Character], String>.failure("coding error")
                    completion(codingError)
                }
                
            case .failure(let error):
                let codingError = RMResult<[Character], String>.failure(error)
                completion(codingError)
            }
        }
    }
    
    private func startCharacterPaginationNetworkCall(url: URL, completion: @escaping (RMResult<CharacterPagination, String>) -> Void) {
        networkManager.httpGet(url: url) { result in
            switch result {
            case .success(let charactersData):
                if let characters = try? JSONDecoder().decode(CharacterPagination.self, from: charactersData) {
                    let charactersResult = RMResult<CharacterPagination, String>.success(characters)
                    completion(charactersResult)
                } else {
                    let codingError = RMResult<CharacterPagination, String>.failure("coding error")
                    completion(codingError)
                }
                
            case .failure(let error):
                let codingError = RMResult<CharacterPagination, String>.failure(error)
                completion(codingError)
            }
        }
    }
}
