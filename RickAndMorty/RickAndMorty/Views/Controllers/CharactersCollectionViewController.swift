//
//  CharactersCollectionViewController.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import UIKit

protocol CharactersCollectionViewProtocol: AnyObject {
    func loadCharactersCollection(characters: [Character])
}

class CharactersCollectionViewController: UIViewController {
    private let presenter = CharactersCollectionPresenter()
    private var charactersViews: CharactersCollectionView?

    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCharactersView()
        self.presenter.loadCharacters()
        self.presenter.setCharacterViewProtocol(viewProtocol: self)
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
    func loadCharactersCollection(characters: [Character]) {
        DispatchQueue.main.async {
            self.charactersViews?.reloadWith(characters: characters)
        }
    }
}

extension CharactersCollectionViewController: CharactersCollectionViewDelegate {
    func characterSelected(character: Character) {
        print(character)
    }
    
    func loadNextPage() {
        self.presenter.loadCharacters()
    }
    
}
