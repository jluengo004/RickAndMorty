//
//  CharactersCollectionPresenter.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

class CharactersCollectionPresenter {
    private var characterCount = 1
    private var characters: [Character] = []
    weak var charactersCollectionVCProtocol: CharactersCollectionViewProtocol?
    
    func setCharacterViewProtocol(viewProtocol: CharactersCollectionViewProtocol) {
        self.charactersCollectionVCProtocol = viewProtocol
    }
    
    func loadCharacters() {
        let service = CharacterService()
        service.getCharacterPage(page: characterCount) { result in
            switch result {
            case .success(let charactersPagination):
                self.characters.append(contentsOf: charactersPagination.results)
                self.charactersCollectionVCProtocol?.loadCharacters(characters: self.characters)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
