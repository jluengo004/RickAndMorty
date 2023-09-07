//
//  CharacterCollectionTests.swift
//  RickAndMortyTests
//
//  Created by Jon Luengo on 7/9/23.
//

import Foundation
import XCTest
@testable import RickAndMorty

class CharacterCollectionViewProtocol: CharactersCollectionViewProtocol {
    var loadedCharacters = false
    var toastCalled = false

    func loadCharactersCollection(characters: [Character], filters: CharacterFilterParams?) { loadedCharacters = true }
    func emptyFilterCharacters() { toastCalled = true }
}


final class CharacterCollectionTests: BaseTest {
    var presenter: CharactersCollectionPresenter!
    var charactersView: CharacterCollectionViewProtocol!
    
    override func setUp() {
        presenter = CharactersCollectionPresenter()
        charactersView = CharacterCollectionViewProtocol()
        presenter.setCharacterViewProtocol(viewProtocol: charactersView)
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        charactersView = nil
        try super.tearDownWithError()
    }

    func test_loadCharactersSuccess() throws {
        presenter.characterService = CharacterServiceSuccessMock()
        XCTAssert(presenter.characters.count == 0)
        presenter.loadCharacters()
        XCTAssert(presenter.characters.count > 0)
        XCTAssertTrue(charactersView.loadedCharacters)
    }
    
    func test_loadCharactersFail() throws {
        presenter.characterService = CharacterServiceFailureMock()
        XCTAssert(presenter.characters.count == 0)
        presenter.loadCharacters()
        XCTAssert(presenter.characters.count == 0)
    }
    
    func test_loadFilterCharactersSuccess() throws {
        let filters = CharacterFilterParams(ids: nil, name: "Rick", status: .alive,
                                            species: nil, type: nil, gender: .male)
        presenter.resetFilters(filters: filters)
        presenter.characterService = FilterCharacterServiceSuccessMock()
        XCTAssert(presenter.filteredCharacters.count == 0)
        presenter.loadFilterCharacters()
        XCTAssert(presenter.filteredCharacters.count > 0)
        XCTAssertTrue(charactersView.loadedCharacters)
    }
    
    func test_loadFilterCharactersFail() throws {
        let filters = CharacterFilterParams(ids: nil, name: "Morty", status: .dead,
                                            species: nil, type: nil, gender: .female)
        presenter.resetFilters(filters: filters)
        presenter.characterService = CharacterServiceFailureMock()
        XCTAssert(presenter.filteredCharacters.count == 0)
        presenter.loadFilterCharacters()
        XCTAssert(presenter.filteredCharacters.count == 0)
        XCTAssertTrue(charactersView.toastCalled)
    }

}

// MARK: Services Mock's
class CharacterServiceSuccessMock: CharacterService {
    override func startCharacterPaginationNetworkCall(url: URL, completion: @escaping (RMResult<CharacterPagination, String>) -> Void) {
        let jsonData = (try? JSONHelper().getData(bundle: Bundle(for: type(of: self)), for: "CharactersMockup")) ?? Data()
        let characterPagination: CharacterPagination? =  try? JSONDecoder().decode(CharacterPagination.self, from: jsonData)
        if let characterPagination = characterPagination {
            let serviceResult = RMResult<CharacterPagination, String>.success(characterPagination)
            completion(serviceResult)
        } else {
            let error = "No characters found"
            let serviceResult = RMResult<CharacterPagination, String>.failure(error)
            completion(serviceResult)
        }
    }
}

class FilterCharacterServiceSuccessMock: CharacterService {
    override func startCharacterPaginationNetworkCall(url: URL, completion: @escaping (RMResult<CharacterPagination, String>) -> Void) {
        let jsonData = (try? JSONHelper().getData(bundle: Bundle(for: type(of: self)), for: "CharactersFilterMockup")) ?? Data()
        let characterPagination: CharacterPagination? =  try? JSONDecoder().decode(CharacterPagination.self, from: jsonData)
        if let characterPagination = characterPagination {
            let serviceResult = RMResult<CharacterPagination, String>.success(characterPagination)
            completion(serviceResult)
        } else {
            let error = "No characters found"
            let serviceResult = RMResult<CharacterPagination, String>.failure(error)
            completion(serviceResult)
        }
    }
}

class CharacterServiceFailureMock: CharacterService {
    override func startCharacterPaginationNetworkCall(url: URL, completion: @escaping (RMResult<CharacterPagination, String>) -> Void) {
        let error = "No characters found"
        let serviceResult = RMResult<CharacterPagination, String>.failure(error)
        completion(serviceResult)
    }
}
