//
//  QuizPresenter.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import UIKit
import Combine

final class QuizPresenter {
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
    private var bindings = Set<AnyCancellable>()
    
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
        var episodeNameAsURL = episode.name.replacingOccurrences(of: " ", with: "_")
                                            .replacingOccurrences(of: ",", with: "")
        episodeNameAsURL = episode.episode == "S04E10" ? episodeNameAsURL.replacingOccurrences(of: ":", with: "") : episodeNameAsURL
        let episodeCustomURL = URL(string: baseCustomEpisodeURL + episodeNameAsURL)
        guard let episodeCustomURL = episodeCustomURL else { return }
        episodeService.getEpisodeCustomData(url: episodeCustomURL)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.quizVCProtocol?.showErrorAlert(error: error.localizedDescription)
                }
            } receiveValue: { episodeData in
                let html = String(decoding: episodeData, as: UTF8.self)
                let parsingResult = HTTMLParser().parse(html: html)
                switch parsingResult {
                case .success(let episodeData):
                    episode.setCustomData(info: episodeData)
                    self.quizEpisode = episode
                    completion(episode)
                case .failure(_):
                    completion(nil)
                }
            }
            .store(in: &bindings)
    }
    
    func loadAllEpisodes() {
        episodeService.getEpisodePage(page: episodePageCount)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.quizVCProtocol?.showErrorAlert(error: error.localizedDescription)
                }
            } receiveValue: { episodesPagination in
                self.episodes.append(contentsOf: episodesPagination.results)
                if episodesPagination.info.next != nil {
                    self.episodePageCount += 1
                    self.loadAllEpisodes()
                }
            }
            .store(in: &bindings)
    }
    
    func getEpisodes() -> [Episode] {
        return episodes
    }
    
    func loadAllCharacters() {
        characterService.getCharacterPage(page: characterPageCount)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.quizVCProtocol?.showErrorAlert(error: error.localizedDescription)
                }
            } receiveValue: { charactersPagination in
                self.characters.append(contentsOf: charactersPagination.results)
                if charactersPagination.info.next != nil {
                    self.characterPageCount += 1
                    self.loadAllCharacters()
                } else {
                    self.quizVCProtocol?.loadQuizView()
                }
            }
            .store(in: &bindings)
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
