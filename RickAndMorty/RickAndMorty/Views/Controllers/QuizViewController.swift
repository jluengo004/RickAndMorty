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
    func loadCorrectGuess(character: Character)
    func loadIncorrectGuess()
}

class QuizViewController: UIViewController {
    private let presenter: QuizPresenter?
    private var charactersViews: CharactersCollectionView?
    private var episode: Episode?
    private var charactersToGuess: [Character]?
    private var allCharacters: [Character]?
    private var filteredCharacters: [Character]?
    private var unsolvedCharacters: [Character]?

    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var portraitsStackView: UIStackView!
    @IBOutlet weak var characterNamesTableView: UITableView!
    
    static func create() -> QuizViewController {
        let presenter = QuizPresenter()
        let view = QuizViewController(presenter: presenter)
        presenter.setQuizViewProtocol(viewProtocol: view)
        return view
    }
    
    init(presenter: QuizPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.setQuizViewProtocol(viewProtocol: self)
        self.setNavigationBar()
        self.configureCharactersNameTable()
        self.configureCharactersView()
        self.presenter?.loadAllEpisodes()
        self.presenter?.loadAllCharacters()
    }
    
    func setNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = "QUIZ"
        
        let filterButton: UIBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(refreshClicked(_:)))
        filterButton.setBackgroundImage(UIImage(named: "refreshIcon"), for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    func loadAndConfigureView() {
        self.allCharacters = self.presenter?.getCharacters()
        self.filteredCharacters = allCharacters
        self.nameTextField.delegate = self
        self.presenter?.selectAndLoadEpisode { episode in
            self.episode = episode
            self.configureView()
        }
    }
    
    func configureCharactersNameTable() {
        let characterNameTableViewCell = UINib(nibName: "CharacterNameTableViewCell", bundle: nil)
        self.characterNamesTableView.register(characterNameTableViewCell, forCellReuseIdentifier: CharacterNameTableViewCell.identifier)
        
        self.characterNamesTableView.delegate = self
        self.characterNamesTableView.dataSource = self
        self.characterNamesTableView.isHidden = true
    }
    
    func configureView() {
        DispatchQueue.main.async() { [weak self] in
            self?.nameTextField.layer.cornerRadius = 10
            self?.nameTextField.layer.borderWidth = 1
            self?.nameTextField.layer.borderColor = UIColor.systemGray4.cgColor
            self?.downloadEpisodeImage()
            self?.episodeLabel.text = self?.episode?.name
            self?.episodeLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
            self?.synopsisLabel.text = self?.episode?.synopsis
            self?.guessLabel.text = "Guess the characters that appear in this episode"
            
            let unsolvedCharacter = Character(id: 9999, name: "¿¿??")
            self?.unsolvedCharacters = []
            for _ in 1...(self?.episode?.characters.count ?? 1) {
                self?.unsolvedCharacters?.append(unsolvedCharacter)
            }
            self?.charactersViews?.reloadWith(characters: self?.unsolvedCharacters ?? [])
        }
    }
    
    func downloadEpisodeImage() {
        if let imageURL = self.episode?.image {
            self.presenter?.downloadImage(from: imageURL) { image in
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
    
    @objc func refreshClicked(_ sender: Any) {
        self.loadAndConfigureView()
    }
}

extension QuizViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterNameTableViewCell.identifier,
                                                            for: indexPath) as? CharacterNameTableViewCell
        else { return UITableViewCell() }
        guard let character = filteredCharacters?[indexPath.row]
        else { return UITableViewCell() }
        let shadowColor: UIColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.16)
        cell.layer.shadowColor = shadowColor.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 5
        cell.layer.masksToBounds = false
        cell.delegate = self
        cell.configureView(character: character)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filteredCharacters = filteredCharacters {
            self.presenter?.checkIfGuessedCorrectCharacter(guessedCharacter: filteredCharacters[indexPath.row])
        }
    }
    
}

extension QuizViewController: QuizViewProtocol {
    func loadQuizView() {
        self.loadAndConfigureView()
    }
    
    func loadCorrectGuess(character: Character) {
        self.nameTextField.layer.borderColor = UIColor.green.cgColor
        textFieldDidEndEditing(nameTextField)
        self.nameTextField.text = ""
        self.filteredCharacters = allCharacters
        self.characterNamesTableView.reloadData()
        
        if let index = self.unsolvedCharacters?.indices.filter({ unsolvedCharacters?[$0].id == 9999 }).first {
            self.unsolvedCharacters?[index] = character
        }
        self.charactersViews?.reloadWith(characters: self.unsolvedCharacters ?? [])
    }
    
    func loadIncorrectGuess() {
        self.nameTextField.layer.borderWidth = 1
        self.nameTextField.layer.borderColor = UIColor.red.cgColor
        
        let colorInAnimation = CABasicAnimation(keyPath: "colorIn")
        colorInAnimation.duration = 0.07
        colorInAnimation.fromValue = self.nameTextField.layer.borderColor = UIColor.systemGray4.cgColor
        colorInAnimation.toValue = self.nameTextField.layer.borderColor = UIColor.red.cgColor
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.duration = 0.07
        positionAnimation.repeatCount = 4
        positionAnimation.autoreverses = true
        positionAnimation.fromValue = NSValue(cgPoint: CGPoint(x: nameTextField.center.x - 10, y: nameTextField.center.y))
        positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: nameTextField.center.x + 10, y: nameTextField.center.y))

        
        self.nameTextField.layer.add(positionAnimation, forKey: "position")
        self.nameTextField.layer.add(colorInAnimation, forKey: "colorIn")
        self.nameTextField.text = ""
        self.filteredCharacters = allCharacters
        self.characterNamesTableView.reloadData()
    }
}

extension QuizViewController: CharacterCollecionViewCellDelegate {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        self.presenter?.downloadImage(from: url) { image in
            completion(image)
        }
    }
}

extension QuizViewController: CharactersCollectionViewDelegate {
    func loadNextPage() {}
}

extension QuizViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == nil || textField.text == "" {
            self.filteredCharacters = self.allCharacters
        } else {
            self.filteredCharacters = self.allCharacters?.filter { $0.name.lowercased().contains(textField.text?.lowercased() ?? "") }
        }
        self.characterNamesTableView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.characterNamesTableView.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.characterNamesTableView.isHidden = false
            self.characterNamesTableView.alpha = 1.0
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.characterNamesTableView.isHidden = true
            self.characterNamesTableView.alpha = 0.0
            textField.resignFirstResponder()
        }
    }
}



