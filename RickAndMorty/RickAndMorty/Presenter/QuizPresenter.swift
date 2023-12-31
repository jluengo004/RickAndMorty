//
//  QuizPresenter.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import UIKit

class QuizPresenter {
    private var quizVCProtocol: QuizViewProtocol?
    var episodeService = EpisodeService()
    var characterService = CharacterService()
    private var characterPageCount = 1
    private var episodePageCount = 1
    var characters: [Character] = []
    var episodes: [Episode] = []
    var quizEpisode: Episode?
    private let imageCache = NSCache<AnyObject, AnyObject>()
    private let baseCustomEpisodeURL = "https://rickandmorty.fandom.com/wiki/"
    
    func setQuizViewProtocol(viewProtocol: QuizViewProtocol) {
        self.quizVCProtocol = viewProtocol
    }
    
    func checkIfGuessedCorrectCharacter(guessedCharacter: Character) {
        let correctCharacter = quizEpisode?.characters.filter { $0 == guessedCharacter.url }.first
        if correctCharacter == nil {
            self.quizVCProtocol?.loadIncorrectGuess()
        } else {
            self.quizVCProtocol?.loadCorrectGuess(character: guessedCharacter)
        }
    }
    
    func selectAndLoadEpisode(completion: @escaping (Episode?) -> Void) {
        var episode = episodes[Int.random(in: 0...(episodes.count - 1))]
        let episodeNameAsURL = episode.name.replacingOccurrences(of: " ", with: "_")
        let episodeCustomURL = URL(string: baseCustomEpisodeURL + episodeNameAsURL)
        guard let episodeCustomURL = episodeCustomURL else { return }
        episodeService.getEpisodeCustomData(url: episodeCustomURL) { result in
            switch result {
            case .success(let response):
                episode.setCustomData(info: response)
                self.quizEpisode = episode
                completion(episode)
            case .failure(let errorModel):
                print (errorModel)
                completion(nil)
            }
        }
    }
    
    func loadAllEpisodes() {
        episodeService.getEpisodePage(page: episodePageCount) { result in
            switch result {
            case .success(let episodesPagination):
                self.episodes.append(contentsOf: episodesPagination.results)
                if episodesPagination.info.next != nil {
                    self.episodePageCount += 1
                    self.loadAllEpisodes()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getEpisodes() -> [Episode] {
        return episodes
    }
    
    func loadAllCharacters() {
        characterService.getCharacterPage(page: characterPageCount) { result in
            switch result {
            case .success(let charactersPagination):
                self.characters.append(contentsOf: charactersPagination.results)
                if charactersPagination.info.next != nil {
                    self.characterPageCount += 1
                    self.loadAllCharacters()
                } else {
                    self.quizVCProtocol?.loadQuizView()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCharacters() -> [Character] {
        return characters
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        ImageLoadingAndCaching().getImage(from: url) { image in
            completion(image)
        }
    }
    
}
