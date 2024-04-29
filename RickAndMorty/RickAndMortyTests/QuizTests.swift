//
//  QuizTests.swift
//  RickAndMortyTests
//
//  Created by Jon Luengo on 7/9/23.
//

import Foundation
import XCTest
@testable import RickAndMorty

final class QuizMockView: QuizViewProtocol {
    var loadedQuiz = false
    var loadedCorrectGuess = false
    var loadedIncorrectGuess = false
    
    func loadQuizView() { loadedQuiz = true }
    func loadCorrectGuess(character: Character) { loadedCorrectGuess = true }
    func loadIncorrectGuess() { loadedIncorrectGuess = true }
}

final class QuizTests: BaseTest {
    var presenter: QuizPresenter!
    var quizView: QuizMockView!
    
    override func setUp() {
        presenter = QuizPresenter()
        quizView = QuizMockView()
        presenter.setQuizViewProtocol(viewProtocol: quizView)
        super.setUp()
    }

    override func tearDownWithError() throws {
        presenter = nil
        quizView = nil
        try super.tearDownWithError()
    }

    func test_loadAllEpisodesSuccess() throws {
        presenter.episodeService = EpisodeServiceSuccessMock()
        XCTAssert(presenter.episodes.count == 0)
        presenter.loadAllEpisodes()
        XCTAssert(presenter.episodes.count > 0)
    }
    
    func test_loadAllEpisodesFail() throws {
        presenter.episodeService = EpisodeServiceFailureMock()
        XCTAssert(presenter.episodes.count == 0)
        presenter.loadAllEpisodes()
        XCTAssert(presenter.episodes.count == 0)
    }
    
    func test_loadAllCharactersSuccess() throws {
        presenter.characterService = CharacterServiceSuccessMock()
        XCTAssert(presenter.characters.count == 0)
        presenter.loadAllCharacters()
        XCTAssert(presenter.characters.count > 0)
        XCTAssertTrue(quizView.loadedQuiz)
    }
    
    func test_loadAllCharactersFail() throws {
        presenter.characterService = CharacterServiceFailureMock()
        XCTAssert(presenter.characters.count == 0)
        presenter.loadAllCharacters()
        XCTAssert(presenter.characters.count == 0)
        XCTAssertFalse(quizView.loadedQuiz)
    }
    
    func test_selectRandomEpisodeAndGuessCorrectCharacter() throws {
        presenter.episodeService = EpisodeCustomInfoServiceSuccessMock()
        let jsonData = (try? JSONHelper().getData(bundle: bundle, for: "EpisodesMockup")) ?? Data()
        let episodesPagination: EpisodePagination? =  try? JSONDecoder().decode(EpisodePagination.self, from: jsonData)
        
        let characterjsonData = (try? JSONHelper().getData(bundle: bundle, for: "CharactersMockup")) ?? Data()
        let charactersPagination: CharacterPagination? =  try? JSONDecoder().decode(CharacterPagination.self, from: characterjsonData)
        
        presenter.episodes = episodesPagination?.results ?? []
        XCTAssertNil(presenter.quizEpisode)
        presenter.selectAndLoadEpisode(completion: { episode in
            XCTAssertNotNil(self.presenter.quizEpisode)
            XCTAssertNotNil(self.presenter.quizEpisode?.image)
            
            if let rick = charactersPagination?.results.first {
                self.presenter.checkIfGuessedCorrectCharacter(guessedCharacter: rick)
                XCTAssertTrue(self.quizView.loadedCorrectGuess)
            }
        })
    }
    
    func test_selectRandomEpisodeAndGuessIncorrectCharacter() throws {
        presenter.episodeService = EpisodeCustomInfoServiceSuccessMock()
        let jsonData = (try? JSONHelper().getData(bundle: bundle, for: "EpisodesMockup")) ?? Data()
        let episodesPagination: EpisodePagination? =  try? JSONDecoder().decode(EpisodePagination.self, from: jsonData)
        
        presenter.episodes = episodesPagination?.results ?? []
        XCTAssertNil(presenter.quizEpisode)
        presenter.selectAndLoadEpisode(completion: { episode in
            XCTAssertNotNil(self.presenter.quizEpisode)
            XCTAssertNotNil(self.presenter.quizEpisode?.image)
            
            let falseRick = Character(id: 9999, name: "False Rick")
            self.presenter.checkIfGuessedCorrectCharacter(guessedCharacter: falseRick)
            XCTAssertTrue(self.quizView.loadedIncorrectGuess)
        })
    }

}

// MARK: Services Mock's
final class EpisodeServiceSuccessMock: EpisodeService {
    override func startEpisodePaginationNetworkCall(url: URL, completion: @escaping (Result<EpisodePagination, ServiceErrors>) -> Void) {
        let jsonData = (try? JSONHelper().getData(bundle: Bundle(for: type(of: self)), for: "EpisodesMockup")) ?? Data()
        let episodesPagination: EpisodePagination? =  try? JSONDecoder().decode(EpisodePagination.self, from: jsonData)
        if let episodesPagination = episodesPagination {
            completion(.success(episodesPagination))
        } else {
            completion(.failure(.emptyResponse))
        }
    }
}

final class EpisodeServiceFailureMock: EpisodeService {
    override func startEpisodePaginationNetworkCall(url: URL, completion: @escaping (Result<EpisodePagination, ServiceErrors>) -> Void) {
        completion(.failure(.emptyResponse))
    }
}

final class EpisodeCustomInfoServiceSuccessMock: EpisodeService {
    override func getEpisodeCustomData(url: URL, completion: @escaping (Result<(String?, String?), ServiceErrors>) -> Void) {
        let imageURL = "https://static.wikia.nocookie.net/rickandmorty/images/8/89/Rms03e06.s29.png/revision/latest?cb=20171004024102"
        let synopsis = "After another exhausting adventure, Rick and Morty decide they need a vacation. But things go a little haywire when they try a special detox machine."
        completion(.success((imageURL,synopsis)))
    }
}

