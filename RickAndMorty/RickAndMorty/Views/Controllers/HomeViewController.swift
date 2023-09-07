//
//  HomeViewController.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 6/9/23.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
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
        self.wikiButton.setTitle("Boooring", for: .normal)
        self.wikiButton.backgroundColor = UIColor.white
        self.wikiButton.layer.cornerRadius = 10
    }
    
    @IBAction func quizButtonTapped(_ sender: Any) {
        let quizVC = QuizViewController.create()
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
    
    @IBAction func wikiButtonTapped(_ sender: Any) {
        wikiButtonClickCount += 1
        switch wikiButtonClickCount {
        case 1:
             self.wikiButton.setTitle("Really¿?", for: .normal)
             UIView.animate(withDuration: 0.1, delay: 0.0) {
                 self.wikiButton.frame = CGRect(x: self.wikiButton.frame.minX + 100, y: self.wikiButton.frame.minY + 280, width: self.wikiButton.frame.width, height: self.wikiButton.frame.height)
                 self.quizButton.frame = CGRect(x: self.quizButton.frame.minX, y: self.quizButton.frame.minY, width: self.quizButton.frame.width + 20, height: self.quizButton.frame.height + 20)
             }
             DispatchQueue.main.async {
                 self.wallpaperImageView.image = UIImage(named: "wallpaper2")
             }
            
        case 2:
            self.wikiButton.setTitle("You joking, right?", for: .normal)
            UIView.animate(withDuration: 0.1, delay: 0.0) {
                self.wikiButton.frame = CGRect(x: self.wikiButton.frame.minX - 225, y: self.wikiButton.frame.minY - 60, width: self.wikiButton.frame.width, height: self.wikiButton.frame.height)
                self.quizButton.frame = CGRect(x: self.quizButton.frame.minX, y: self.quizButton.frame.minY, width: self.quizButton.frame.width + 20, height: self.quizButton.frame.height + 20)
            }
            DispatchQueue.main.async {
                self.wallpaperImageView.image = UIImage(named: "wallpaper3")
            }
            
        case 3:
            self.wikiButton.setTitle("It's just a wiki", for: .normal)
            UIView.animate(withDuration: 0.1, delay: 0.0) {
                self.wikiButton.frame = CGRect(x: self.wikiButton.frame.minX + 75, y: self.wikiButton.frame.minY - 220, width: self.wikiButton.frame.width, height: self.wikiButton.frame.height)
                self.quizButton.frame = CGRect(x: self.quizButton.frame.minX, y: self.quizButton.frame.minY, width: self.quizButton.frame.width + 20, height: self.quizButton.frame.height + 20)
            }
            DispatchQueue.main.async {
                self.wallpaperImageView.image = UIImage(named: "wallpaper4")
            }
            
        case 4:
            let wikiVC = CharactersCollectionViewController.create()
            self.navigationController?.pushViewController(wikiVC, animated: true)
            
        default:
            let wikiVC = CharactersCollectionViewController.create()
            self.navigationController?.pushViewController(wikiVC, animated: true)
        }
            
    }
}
