//
//  CharactersCollectionPresenter.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation
import UIKit
import Combine

final class CharactersCollectionPresenter {
    private var characterPageCount = 1
    private var isCharacterLastPage = false
    private var filteredCharacterPageCount = 1
    private var isFilteredCharacterLastPage = false
    var characters: [Character] = []
    var filteredCharacters: [Character] = []
    var filters: CharacterFilterParams?
    var characterService = CharacterService()
    weak var charactersCollectionVCProtocol: CharactersCollectionViewProtocol?
    private var bindings = Set<AnyCancellable>()
    
    func setCharacterViewProtocol(viewProtocol: CharactersCollectionViewProtocol) {
        self.charactersCollectionVCProtocol = viewProtocol
    }
    
    func loadCharacters() {
        characterService.getCharacterPage(page: characterPageCount)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.charactersCollectionVCProtocol?.showErrorAlert(error: error.localizedDescription)
                }
            } receiveValue: { charactersPagination in
                self.characters.append(contentsOf: charactersPagination.results)
                self.charactersCollectionVCProtocol?.loadCharactersCollection(characters: self.characters, filters: nil)
                if charactersPagination.info.next != nil {
                    self.characterPageCount += 1
                } else {
                    self.isCharacterLastPage = true
                }
            }
            .store(in: &bindings)
    }
    
    func loadFilterCharacters() {
        if !isFilteredCharacterLastPage {
            guard let filters = self.filters else { return }
            characterService.getFilteredCharacters(params: filters, page: filteredCharacterPageCount)
                .sink { completion in
                    if case .failure(_) = completion {
                        self.charactersCollectionVCProtocol?.emptyFilterCharacters()
                    }
                } receiveValue: { filteredCharactersPagination in
                    self.filteredCharacters.append(contentsOf: filteredCharactersPagination.results)
                    self.charactersCollectionVCProtocol?.loadCharactersCollection(characters: self.filteredCharacters, filters: filters)
                    if filteredCharactersPagination.info.next != nil {
                        self.filteredCharacterPageCount += 1
                    } else {
                        self.isFilteredCharacterLastPage = true
                    }
                }
                .store(in: &bindings)
        }
    }
    
    func resetFilters(filters: CharacterFilterParams?) {
        self.filters = filters
        self.filteredCharacterPageCount = 1
        self.isFilteredCharacterLastPage = false
        self.filteredCharacters.removeAll()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        ImageLoadingAndCaching().getImage(from: url) { image in
            completion(image)
        }
    }
}
