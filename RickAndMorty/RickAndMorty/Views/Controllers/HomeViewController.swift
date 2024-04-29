//
//  HomeViewController.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 6/9/23.
//

import Foundation
import UIKit

final class HomeViewController: UIViewController {
    
    private var wikiButtonClickCount = 0
    
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var wikiButton: UIButton!
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    func setNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = "Welcome To Multiverse"
    }
    
    func setUpView() {
        self.quizButton.setTitle("Let's Have Fun", for: .normal)
        self.quizButton.backgroundColor = UIColor.white
        self.quizButton.layer.cornerRadius = 10
        self.wikiButton.setTitle("Multiverse ID's", for: .normal)
        self.wikiButton.backgroundColor = UIColor.white
        self.wikiButton.layer.cornerRadius = 10
    }
    
    @IBAction func quizButtonTapped(_ sender: Any) {
        let quizVC = QuizViewController.create()
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
    
    @IBAction func wikiButtonTapped(_ sender: Any) {
        let wikiVC = CharactersCollectionViewController.create()
        self.navigationController?.pushViewController(wikiVC, animated: true)
    }
}
