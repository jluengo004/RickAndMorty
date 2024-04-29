//
//  QuizTests.swift
//  RickAndMortyTests
//
//  Created by Jon Luengo on 7/9/23.
//

import Foundation
import XCTest
import Combine
@testable import RickAndMorty

final class QuizMockView: QuizViewProtocol {
    var loadedQuiz = false
    var loadedCorrectGuess = false
    var loadedIncorrectGuess = false
    var errorCalled = false
    
    func loadQuizView() { loadedQuiz = true }
    func loadCorrectGuess(character: Character) { loadedCorrectGuess = true }
    func loadIncorrectGuess() { loadedIncorrectGuess = true }
    func showErrorAlert(error: String) { errorCalled = true }
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
        presenter.episodeService = EpisodeServiceSuccessMock()
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
        presenter.episodeService = EpisodeServiceSuccessMock()
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
    public override func getEpisodeCustomData(url: URL) -> AnyPublisher<Data, ServiceErrors> {
        let data = Data()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("CustomEpisodeDataMockup.txt")
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                let data = try Data(contentsOf: fileURL)
                return Future<Data, ServiceErrors> { promise in
                    promise(.success(data))
                }
                .eraseToAnyPublisher()
            }
            catch {/* error handling here */}
        }
        return Fail<Data, ServiceErrors>(error: .emptyResponse).eraseToAnyPublisher()
    }
    
    public override func getEpisodePage(page: Int) -> AnyPublisher<EpisodePagination, ServiceErrors> {
        let jsonData = (try? JSONHelper().getData(bundle: Bundle(for: type(of: self)), for: "EpisodesMockup")) ?? Data()
        let episodePagination: EpisodePagination? =  try? JSONDecoder().decode(EpisodePagination.self, from: jsonData)
        if let episodePagination = episodePagination {
            return Future<EpisodePagination, ServiceErrors> { promise in
                promise(.success(episodePagination))
            }
            .eraseToAnyPublisher()
        } else {
            return Fail<EpisodePagination, ServiceErrors>(error: .emptyResponse).eraseToAnyPublisher()
        }
    }
}

final class EpisodeServiceFailureMock: EpisodeService {
    public override func getEpisodeCustomData(url: URL) -> AnyPublisher<Data, ServiceErrors> {
        return Fail<Data, ServiceErrors>(error: .emptyResponse).eraseToAnyPublisher()
    }
}

