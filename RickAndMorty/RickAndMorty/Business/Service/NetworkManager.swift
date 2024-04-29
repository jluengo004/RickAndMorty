//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation
import Combine

public enum ServiceErrors: Error, LocalizedError {
    case networkError(String, Int?), emptyResponse, urlError(String), paramError, decodingError(String)
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let description, let code):
            return "Network error: \(description) with code \(code ?? 400)"
        case .emptyResponse:
            return "No model retrieved from response"
        case .urlError(let url):
            return "Incorrect URL \(url)"
        case .paramError:
            return "Incorrect parameters"
        case .decodingError(let modelName):
            return "Unable to decode servide response into \(modelName)"
        }
    }
}

public final class NetworkManager {
    
    private var bindings = Set<AnyCancellable>()
    
    public func httpGet(url: URL) -> AnyPublisher<Data, ServiceErrors> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let cache = RealmManager()
        cache.fetchAllObjects()
        if let dataCache = fetchFromCache(url: url.absoluteString) {
            return Future<Data, ServiceErrors> { promise in
                promise(.success(dataCache))
            }
            .eraseToAnyPublisher()
        } else {
            let networkPublisher = URLSession.shared
                .dataTaskPublisher(for: url)
                .map { $0.data }
                .mapError { error -> ServiceErrors in
                    return .networkError(error.localizedDescription, error.errorCode)
                }
                .share()
                .eraseToAnyPublisher()
            
            networkPublisher.sink { completion in
                
            } receiveValue: { data in
                self.saveInCache(url: url.absoluteString, data: data)
            }
            .store(in: &bindings)

            return networkPublisher
        }
        
    }
    
    func saveInCache(url: String, data: Data) {
        let cache = RealmManager()
        let cacheObject = RealmCacheObject(serviceData: data, url: url)
        let _ = cache.saveObject(cacheObject: cacheObject)
    }
    
    func fetchFromCache(url: String) -> Data? {
        let cache = RealmManager()
        if let fetchedData = cache.fetchObjects(url: url) {
            return fetchedData
        } else {
            return nil
        }
    }
    
}
