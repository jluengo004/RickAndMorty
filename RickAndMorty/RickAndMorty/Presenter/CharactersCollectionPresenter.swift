//
//  CharactersCollectionPresenter.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation
import UIKit

class CharactersCollectionPresenter {
    private var characterPageCount = 1
    private var filteredCharacterPageCount = 1
    private var characters: [Character] = []
    private var filteredCharacters: [Character] = []
    private var filters: CharacterFilterParams?
    private let imageCache = NSCache<AnyObject, AnyObject>()
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
                self.charactersCollectionVCProtocol?.loadCharactersCollection(characters: self.characters, filters: nil)
                if charactersPagination.info.next != nil {
                    self.characterPageCount += 1
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadFilterCharacters() {
        let service = CharacterService()
        guard let filters = self.filters else { return }
        service.getFilteredCharacters(params: filters, page: filteredCharacterPageCount) { result in
            switch result {
            case .success(let filteredCharactersPagination):
                self.filteredCharacters.append(contentsOf: filteredCharactersPagination.results)
                self.charactersCollectionVCProtocol?.loadCharactersCollection(characters: self.filteredCharacters, filters: filters)
                if filteredCharactersPagination.info.next != nil {
                    self.filteredCharacterPageCount += 1
                }
                
            case .failure(_):
                self.charactersCollectionVCProtocol?.emptyFilterCharacters()
            }
        }
    }
    
    func resetFilters(filters: CharacterFilterParams?) {
        self.filters = filters
        self.filteredCharacterPageCount = 1
        self.filteredCharacters.removeAll()
    }
    
    func getImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(imageFromCache)
        } else {
            downloadImage(from: url) { image in
                completion(image)
            }
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        getData(from: url) { imageData, response, error in
            guard let imageData = imageData, error == nil else { return }
            if let image = UIImage(data: imageData) {
                self.imageCache.setObject(image, forKey: url as AnyObject)
                completion(image)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
