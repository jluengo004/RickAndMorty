//
//  CharacterService.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

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

public class CharacterFilterParams {
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
    
    func getQueryFilterParams() -> [URLQueryItem] {
        var queryParams: [URLQueryItem] = []
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
    
    func getLabelFilterParams() -> String {
        var filterString = ""
        if let name = name, !name.isEmpty {
            filterString += "Name: \(name)  "
        }
        if let status = status {
            filterString += "Status: \(status.rawValue)  "
        }
        if let species = species, !species.isEmpty {
            filterString += "Species: \(species)  "
        }
        if let type = type, !type.isEmpty {
            filterString += "Type: \(type)  "
        }
        if let gender = gender {
            filterString += "Gender: \(gender.rawValue)  "
        }
        
        return filterString
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
    
    public func getFilteredCharacters(params: CharacterFilterParams, completion: @escaping (RMResult<CharacterPagination, String>) -> Void) {
        var urlComps = URLComponents(string: baseURL)
        urlComps?.queryItems = params.getQueryFilterParams()
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
