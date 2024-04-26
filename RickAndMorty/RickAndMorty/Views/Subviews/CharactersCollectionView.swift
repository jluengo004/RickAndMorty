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
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class CharactersCollectionView: UIView  {
    private var characters: [Character] = []
    private var isPageRefreshing: Bool = false
    public var selectedIndexPath: IndexPath?
    weak var delegate: CharactersCollectionViewDelegate?
    private var isQuiz = false
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    func initialize(isQuiz: Bool = false) {
        self.isQuiz = isQuiz
        registerCells()
    }

    fileprivate func registerCells() {
        let characterCollecionViewCellNib = UINib(nibName: "CharacterCollecionViewCell", bundle: nil)
        let characterPortraitCollectionViewCellNib = UINib(nibName: "CharacterPortraitCollectionViewCell", bundle: nil)
        charactersCollectionView.register(characterCollecionViewCellNib, forCellWithReuseIdentifier: CharacterCollecionViewCell.identifier)
        charactersCollectionView.register(characterPortraitCollectionViewCellNib, forCellWithReuseIdentifier: CharacterPortraitCollectionViewCell.identifier)
        charactersCollectionView.dataSource = self
        charactersCollectionView.prefetchDataSource = self
        charactersCollectionView.delegate = self
    }
    
    func reloadWith(characters: [Character]) {
        self.characters = characters
        self.charactersCollectionView.reloadData()
        isPageRefreshing = false
    }
    
    func reloadCorrect(characters: [Character], position: Int) {
        self.characters = characters
        self.charactersCollectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
        isPageRefreshing = false
    }
}

extension CharactersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let index = selectedIndexPath, index == indexPath {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollecionViewCell.identifier,
                                                                for: indexPath) as? CharacterCollecionViewCell
            else { return UICollectionViewCell() }
            let shadowColor: UIColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16)
            cell.layer.shadowColor = shadowColor.cgColor
            cell.layer.shadowOpacity = 1
            cell.layer.shadowOffset = .zero
            cell.layer.shadowRadius = 5
            cell.layer.masksToBounds = false
            cell.delegate = self
            cell.configureView(character: characters[indexPath.row])
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterPortraitCollectionViewCell.identifier,
                                                                for: indexPath) as? CharacterPortraitCollectionViewCell
            else { return UICollectionViewCell() }
            let shadowColor: UIColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16)
            cell.layer.shadowColor = shadowColor.cgColor
            cell.layer.shadowOpacity = 1
            cell.layer.shadowOffset = .zero
            cell.layer.shadowRadius = 5
            cell.layer.masksToBounds = false
            cell.contentView.layer.cornerRadius = 10
            cell.delegate = self
            cell.configureView(character: characters[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isQuiz {
            if indexPath != self.selectedIndexPath {
                if let selectedIndex = self.selectedIndexPath {
                    self.selectedIndexPath = indexPath
                    self.charactersCollectionView.reloadItems(at: [selectedIndex])
                }
                self.selectedIndexPath = indexPath
                self.charactersCollectionView.reloadItems(at: [indexPath])
                self.charactersCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            } else {
                self.selectedIndexPath = nil
                self.charactersCollectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == self.selectedIndexPath {
            return CGSize(width: 380, height: 208)
        } else {
            if isQuiz {
                return CGSize(width: 100, height: 150)
            } else {
                return CGSize(width: 180, height: 235)
            }
        }
    }
    
}

extension CharactersCollectionView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.last?.row ?? 0 > characters.count - 8 && !isPageRefreshing {
            isPageRefreshing = true
            delegate?.loadNextPage()
        }
    }
}


extension CharactersCollectionView: CharacterCollecionViewCellDelegate {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        self.delegate?.loadImage(from: url, completion: { image in
            completion(image)
        })
    }
}
