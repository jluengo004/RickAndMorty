//
//  CharactersCollectionViewController.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import UIKit

protocol CharactersCollectionViewProtocol: AnyObject {
    func loadCharactersCollection(characters: [Character], filters: CharacterFilterParams?)
    func emptyFilterCharacters()
}

class CharactersCollectionViewController: UIViewController {
    private let presenter = CharactersCollectionPresenter()
    private var charactersViews: CharactersCollectionView?
    private var characterFilterBackdrop: CharacterFilterBackdrop?
    private var filters: CharacterFilterParams?
    private var unfilteredCharacters: [Character]?

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var dismissFilterButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.setCharacterViewProtocol(viewProtocol: self)
        self.setNavigationBar()
        self.setUpFilterLabel()
        self.setInitifialFilters()
        self.configureCharactersView()
        self.presenter.loadCharacters()
    }
    
    func setNavigationBar() {
        self.title = "Multiverse IDs"
        let filterButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(filterClicked(_:)))
        filterButton.setBackgroundImage(UIImage(named: "filterIcon"), for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    func setUpFilterLabel() {
        self.filterLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        self.filterLabel.tintColor = UIColor.systemGray5
        self.filterView.layer.borderColor = UIColor.systemGray4.cgColor
        self.filterView.layer.borderWidth = 1
        self.filterView.layer.cornerRadius = 5
        self.filterView.backgroundColor = UIColor.systemGray6
    }
    
    func setInitifialFilters() {
        self.filters = nil
        self.filterLabel.text = ""
        self.dismissFilterButton.setTitle("", for: .normal)
        let originIndexPath = IndexPath(row: 0, section: 0)
        self.charactersViews?.charactersCollectionView.scrollToItem(at: originIndexPath, at: .top, animated: false)
        self.filterView.isHidden = true
    }
    
    func modifyFilterView() {
        DispatchQueue.main.async {
            self.filterLabel.attributedText = self.filters?.getLabelFilterParams()
            let originIndexPath = IndexPath(row: 0, section: 0)
            self.charactersViews?.charactersCollectionView.scrollToItem(at: originIndexPath, at: .top, animated: false)
            self.filterView.isHidden = false
        }
    }
    
    @IBAction func dismissFiltersTapped(_ sender: Any) {
        self.setInitifialFilters()
        self.charactersViews?.selectedIndexPath = nil
        DispatchQueue.main.async {
            if let unfilteredCharacters = self.unfilteredCharacters {
                self.charactersViews?.reloadWith(characters: unfilteredCharacters)
            }
        }
    }
    
    @objc func filterClicked(_ sender: Any){
        self.characterFilterBackdrop = CharacterFilterBackdrop()
        self.characterFilterBackdrop?.addCharacterFilterBackdrop(viewMain: self.view, filters: self.filters, delegate: self)
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
    func loadCharactersCollection(characters: [Character], filters: CharacterFilterParams?) {
        if self.filters != filters {
            self.modifyFilterView()
        }
        self.filters = filters
        if self.filters == nil {
            self.unfilteredCharacters = characters
        }
        DispatchQueue.main.async {
            self.charactersViews?.reloadWith(characters: characters)
        }
    }
    
    func emptyFilterCharacters() {
        DispatchQueue.main.async {
            self.showToast(message: "No character meets that filter", isError: true)
        }
    }
}

extension CharactersCollectionViewController: CharactersCollectionViewDelegate {
    func loadNextPage() {
        if self.filters != nil {
            self.presenter.loadFilterCharacters()
        } else {
            self.presenter.loadCharacters()
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        self.presenter.downloadImage(from: url) { image in
            completion(image)
        }
    }
    
}

extension CharactersCollectionViewController: CharacterFilterBackdropDelegate {
    func searchCharacters(filters: CharacterFilterParams) {
        self.charactersViews?.selectedIndexPath = nil
        self.presenter.resetFilters(filters: filters)
        self.presenter.loadFilterCharacters()
        self.characterFilterBackdrop?.removeFromSuperview()
    }
    
    func dismissView() {
        self.characterFilterBackdrop?.removeFromSuperview()
    }
    
}
