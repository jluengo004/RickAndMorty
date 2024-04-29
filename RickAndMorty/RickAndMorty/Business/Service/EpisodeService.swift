//
//  EpisodeService.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import Combine

public class EpisodeService {
    
    private let baseURL = "https://rickandmortyapi.com/api/episode/"
    private let networkManager = NetworkManager()
    
    public func getEpisodeCustomData(url: URL) -> AnyPublisher<Data, ServiceErrors> {
        return networkManager.httpGet(url: url)
            .share()
            .eraseToAnyPublisher()
    }
    
    public func getEpisodePage(page: Int) -> AnyPublisher<EpisodePagination, ServiceErrors> {
        guard let url = URL(string: baseURL + "?page=\(page)") else {
            return Fail<EpisodePagination, ServiceErrors>(error: .urlError(baseURL + "?page=\(page)")).eraseToAnyPublisher()
        }
        return networkManager.httpGet(url: url)
            .decode(type: EpisodePagination.self, decoder: JSONDecoder())
            .mapError { error in .decodingError(String(describing: EpisodePagination.self)) }
            .share()
            .eraseToAnyPublisher()
    }
    
}
