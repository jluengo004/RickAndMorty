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
    
    public func getEpisodeCustomData(url: URL, completion: @escaping (Result<(String?, String?), ServiceErrors>) -> Void) {
        networkManager.httpGet(url: url) { result in
            switch result {
            case .success(let htmlData):
                let html = String(decoding: htmlData, as: UTF8.self)
                let parsingResult = HTTMLParser().parse(html: html)
                switch parsingResult {
                case .success(let episodeData):
                    completion(.success(episodeData))
                case .failure(let serviceError):
                    completion(.failure(serviceError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getEpisodePage(page: Int, completion: @escaping (Result<EpisodePagination, ServiceErrors>) -> Void) {
        guard let url = URL(string: baseURL + "?page=\(page)") else {
            completion(.failure(.urlError))
            return
        }
        startEpisodePaginationNetworkCall(url: url) { result in
            completion(result)
        }
    }
    
    func startEpisodePaginationNetworkCall(url: URL, completion: @escaping (Result<EpisodePagination, ServiceErrors>) -> Void) {
        networkManager.httpGet(url: url) { result in
            switch result {
            case .success(let episodesData):
                if let episodes = try? JSONDecoder().decode(EpisodePagination.self, from: episodesData) {
                    completion(.success(episodes))
                } else {
                    completion(.failure(.decodingError("EpisodePagination")))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
