//
//  QuizViewController.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 6/9/23.
//

import Foundation
import UIKit

protocol QuizViewProtocol: AnyObject {
    func loadQuizView()
}

class QuizViewController: UIViewController {
    private let presenter = QuizPresenter()
    private var charactersViews: CharactersCollectionView?
    private var episode: Episode?
    private var charactersToGuess: [Character]?
    private var allCharacters: [Character]?

    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var portraitsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.setQuizViewProtocol(viewProtocol: self)
        self.setNavigationBar()
        self.configureCharactersView()
        presenter.loadAllEpisodes()
        presenter.loadAllCharacters()
    }
    
    func setNavigationBar() {
        self.title = "QUIZ"
    }
    
    func loadAndConfigureView() {
        self.allCharacters = self.presenter.getCharacters()
        self.presenter.selectAndLoadEpisode { episode in
            self.episode = episode
            self.configureView()
        }
    }
    
    func configureView() {
        DispatchQueue.main.async() { [weak self] in
            self?.downloadEpisodeImage()
            self?.episodeLabel.text = self?.episode?.name
            self?.episodeLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
            self?.guessLabel.text = "Guess the characters that appear in this episode"
            
            let unsolvedCharacter = Character(id: 9999, name: "¿¿??")
            var unsolvedCharacters: [Character] = []
            for _ in 1...(self?.episode?.characters.count ?? 1) {
                unsolvedCharacters.append(unsolvedCharacter)
            }
            self?.charactersViews?.reloadWith(characters: unsolvedCharacters)
        }
    }
    
    func downloadEpisodeImage() {
        if let imageURL = self.episode?.image {
            self.presenter.downloadImage(from: imageURL) { image in
                DispatchQueue.main.async() { [weak self] in
                    self?.episodeImageView.image = image
                }
            }
        }
    }
    
    func configureCharactersView() {
        guard let charactersViews = UINib(nibName: "CharactersCollectionView", bundle: Bundle(for: CharactersCollectionView.self))
            .instantiate(withOwner: nil).first as? CharactersCollectionView else {
            //TO-DO
            return
        }
        charactersViews.initialize(isQuiz: true)
        charactersViews.delegate = self
        self.portraitsStackView.addArrangedSubview(charactersViews)
        self.charactersViews = charactersViews
    }

}

extension QuizViewController: QuizViewProtocol {
    func loadQuizView() {
        self.loadAndConfigureView()
    }
}

extension QuizViewController: CharactersCollectionViewDelegate {
    func loadNextPage() {
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        self.presenter.downloadImage(from: url) { image in
            completion(image)
        }
    }
    
}
