//
//  EpisodeService.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation

public class EpisodeService {
    
    private let baseURL = "https://rickandmortyapi.com/api/episode/"
    private let networkManager = NetworkManager()
    
    public func getEpisodeCustomData(url: URL, completion: @escaping (RMResult<(String?, String?), String>) -> Void) {
        networkManager.httpGet(url: url) { result in
            switch result {
            case .success(let htmlData):
                let html = String(decoding: htmlData, as: UTF8.self)
                let parsingResult = HTTMLParser().parse(html: html)
                completion(RMResult.success(parsingResult))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func getEpisodePage(page: Int, completion: @escaping (RMResult<EpisodePagination, String>) -> Void) {
        guard let url = URL(string: baseURL + "?page=\(page)") else {
            completion(RMResult.failure("url error"))
            return
        }
        startEpisodePaginationNetworkCall(url: url) { result in
            completion(result)
        }
    }
    
    func startEpisodePaginationNetworkCall(url: URL, completion: @escaping (RMResult<EpisodePagination, String>) -> Void) {
        networkManager.httpGet(url: url) { result in
            switch result {
            case .success(let episodesData):
                if let episodes = try? JSONDecoder().decode(EpisodePagination.self, from: episodesData) {
                    let episodesResult = RMResult<EpisodePagination, String>.success(episodes)
                    completion(episodesResult)
                } else {
                    let codingError = RMResult<EpisodePagination, String>.failure("coding error")
                    completion(codingError)
                }
                
            case .failure(let error):
                let codingError = RMResult<EpisodePagination, String>.failure(error)
                completion(codingError)
            }
        }
    }
    
}
