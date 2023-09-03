//
//  CharactersCollectionView.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation
import UIKit

protocol CharactersCollectionViewDelegate: AnyObject {
    func characterSelected(character: Character)
}

class CharactersCollectionView: UIView  {
    private var characters: [Character] = []
    weak var delegate: CharactersCollectionViewDelegate?
    
    @IBOutlet private weak var charactersCollectionView: UICollectionView!
    
    func initialize() {
        registerCells()
    }

    fileprivate func registerCells() {
        let nib = UINib(nibName: "CharacterCollecionViewCell", bundle: nil)
        charactersCollectionView.register(nib, forCellWithReuseIdentifier: CharacterCollecionViewCell.identifier)
        charactersCollectionView.dataSource = self
        charactersCollectionView.delegate = self
    }
    
    func reloadWith(characters: [Character]) {
        self.characters = characters
        self.charactersCollectionView.reloadData()
    }
}

extension CharactersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 16, bottom: 3, right: 16)
    }

}

extension CharactersCollectionView: CharacterCollecionViewCellDelegate {
    func characterSelected(character: Character) {
        delegate?.characterSelected(character: character)
    }
}

