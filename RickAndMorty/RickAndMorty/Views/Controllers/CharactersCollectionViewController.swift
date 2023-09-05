//
//  CharactersCollectionViewController.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import UIKit

protocol CharactersCollectionViewProtocol: AnyObject {
    func loadCharactersCollection(characters: [Character], isFiltered: Bool)
}

class CharactersCollectionViewController: UIViewController {
    private let presenter = CharactersCollectionPresenter()
    private var charactersViews: CharactersCollectionView?
    private var characterFilterBackdrop: CharacterFilterBackdrop?
    private var isFiltered = false

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.configureCharactersView()
        self.presenter.loadCharacters()
        self.presenter.setCharacterViewProtocol(viewProtocol: self)
    }
    
    func setNavigationBar() {
        self.title = "Multiverse IDs"
        let filterButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(filterClicked(_:)))
        filterButton.setBackgroundImage(UIImage(named: "filterIcon"), for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc func filterClicked(_ sender: Any){
        self.characterFilterBackdrop = CharacterFilterBackdrop()
        self.characterFilterBackdrop?.addCharacterFilterBackdrop(viewMain: self.view, delegate: self)
        characterFilterBackdrop?.containerView.contentView.frame = CGRect(x: characterFilterBackdrop?.containerView.contentView.frame.minX ?? 0,
                                                                          y: (characterFilterBackdrop?.containerView.contentView.frame.minY ?? 0) + (characterFilterBackdrop?.containerView.contentView.frame.height ?? 0),
                                                                          width: characterFilterBackdrop?.containerView.contentView.frame.width ?? 0,
                                                                          height: characterFilterBackdrop?.containerView.contentView.frame.height ?? 0)
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.characterFilterBackdrop?.containerView.contentView.frame = CGRect(x: self.characterFilterBackdrop?.containerView.contentView.frame.minX ?? 0,
                                                                                   y: (self.characterFilterBackdrop?.containerView.contentView.frame.minY ?? 0) - (self.characterFilterBackdrop?.containerView.contentView.frame.height ?? 0),
                                                                                   width: self.characterFilterBackdrop?.containerView.contentView.frame.width ?? 0,
                                                                                   height: self.characterFilterBackdrop?.containerView.contentView.frame.height ?? 0)
        }
    }
    
    func configureCharactersView() {
        guard let charactersViews = UINib(nibName: "CharactersCollectionView", bundle: Bundle(for: CharactersCollectionView.self))
            .instantiate(withOwner: nil).first as? CharactersCollectionView else {
            //TO-DO
            return
        }
        charactersViews.initialize()
        charactersViews.delegate = self
        self.stackView.addArrangedSubview(charactersViews)
        self.charactersViews = charactersViews
    }

}

extension CharactersCollectionViewController: CharactersCollectionViewProtocol {
    func loadCharactersCollection(characters: [Character], isFiltered: Bool) {
        self.isFiltered = isFiltered
        DispatchQueue.main.async {
            self.charactersViews?.reloadWith(characters: characters)
        }
    }
}

extension CharactersCollectionViewController: CharactersCollectionViewDelegate {
    func loadNextPage() {
        if isFiltered {
            self.presenter.loadFilterCharacters()
        } else {
            self.presenter.loadCharacters()
        }
        
    }
    
}

extension CharactersCollectionViewController: CharacterFilterBackdropDelegate {
    func searchCharacters(filters: CharacterServiceParamsModel) {
        self.presenter.resetFilters(filters: filters)
        self.presenter.loadFilterCharacters()
        self.characterFilterBackdrop?.removeFromSuperview()
    }
    
    func dismissView() {
        self.characterFilterBackdrop?.removeFromSuperview()
    }
    
}
