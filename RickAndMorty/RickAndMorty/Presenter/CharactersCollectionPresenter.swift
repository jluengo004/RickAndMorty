//
//  CharactersCollectionPresenter.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

class CharactersCollectionPresenter {
    private var characterPageCount = 1
    private var characters: [Character] = []
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
                self.charactersCollectionVCProtocol?.loadCharactersCollection(characters: self.characters)
                self.characterPageCount += 1
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
