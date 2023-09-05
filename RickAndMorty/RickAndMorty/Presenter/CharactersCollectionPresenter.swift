//
//  CharactersCollectionPresenter.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

class CharactersCollectionPresenter {
    private var characterPageCount = 1
    private var filteredCharacterPageCount = 1
    private var characters: [Character] = []
    private var filteredCharacters: [Character] = []
    private var filters: CharacterServiceParamsModel?
    weak var charactersCollectionVCProtocol: CharactersCollectionViewProtocol?
    
    func setCharacterViewProtocol(viewProtocol: CharactersCollectionViewProtocol) {
        self.charactersCollectionVCProtocol = viewProtocol
    }
    
    func loadCharacters() {
        let service = CharacterService()
        service.getCharacterPage(page: characterPageCount) { result in
            switch result {
            case .success(let charactersPagination):
                self.characters.append(contentsOf: charactersPagination.results)
                self.charactersCollectionVCProtocol?.loadCharactersCollection(characters: self.characters, isFiltered: false)
                self.characterPageCount += 1
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadFilterCharacters() {
        let service = CharacterService()
        guard let filters = self.filters else { return }
        service.getFilteredCharacters(params: filters) { result in
            switch result {
            case .success(let filteredCharactersPagination):
                self.filteredCharacters.append(contentsOf: filteredCharactersPagination.results)
                self.charactersCollectionVCProtocol?.loadCharactersCollection(characters: self.filteredCharacters, isFiltered: true)
                self.filteredCharacterPageCount += 1
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func resetFilters(filters: CharacterServiceParamsModel?) {
        self.filters = filters
        self.filteredCharacterPageCount = 1
        self.filteredCharacters.removeAll()
    }
    
}
