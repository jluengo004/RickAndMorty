//
//  CharactersCollectionView.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation
import UIKit

protocol CharactersCollectionViewDelegate: AnyObject {
    func loadNextPage()
}

class CharactersCollectionView: UIView  {
    private var characters: [Character] = []
    private var isPageRefreshing: Bool = false
    weak var delegate: CharactersCollectionViewDelegate?
    
    @IBOutlet private weak var charactersCollectionView: UICollectionView!
    
    func initialize() {
        registerCells()
    }

    fileprivate func registerCells() {
        let nib = UINib(nibName: "CharacterCollecionViewCell", bundle: nil)
        charactersCollectionView.register(nib, forCellWithReuseIdentifier: CharacterCollecionViewCell.identifier)
        charactersCollectionView.dataSource = self
        charactersCollectionView.prefetchDataSource = self
        charactersCollectionView.delegate = self
    }
    
    func reloadWith(characters: [Character]) {
        self.characters = characters
        self.charactersCollectionView.reloadData()
        isPageRefreshing = false
    }
}

extension CharactersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollecionViewCell.identifier,
                                                            for: indexPath) as? CharacterCollecionViewCell
        else { return UICollectionViewCell() }
        let shadowColor: UIColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16)
        cell.layer.shadowColor = shadowColor.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 5
        cell.layer.masksToBounds = false
        cell.configureView(character: characters[indexPath.row])
        
        return cell
    }
}


extension CharactersCollectionView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.last?.row ?? 0 > characters.count - 4 {
            if !isPageRefreshing {
                isPageRefreshing = true
                delegate?.loadNextPage()
            }
        }
    }
    
}
