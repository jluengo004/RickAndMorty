//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public enum ServiceErrors: Error, LocalizedError {
    case networkError(String, Int?), emptyResponse, urlError, paramError, decodingError(String)
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let description, let code):
            return "Network error: \(description) with code \(code ?? 400)"
        case .emptyResponse:
            return "No model retrieved from response"
        case .urlError:
            return "Incorrect URL"
        case .paramError:
            return "Incorrect parameters"
        case .decodingError(let modelName):
            return "Unable to decode servide response into \(modelName)"
        }
    }
}

public class NetworkManager {
    public func httpGet(url: URL, completion: @escaping (Result<Data, ServiceErrors>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let cache = RealmManager()
        cache.fetchAllObjects()
        if let dataCache = fetchFromCache(url: url.absoluteString) {
            completion(.success(dataCache))
        } else {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    let code = (response as? HTTPURLResponse)?.statusCode
                    completion(.failure(.networkError(error.localizedDescription, code)))
                }
                
                if let data = data {
                    self.saveInCache(url: url.absoluteString, data: data)
                    completion(.success(data))
                }
            }
            task.resume()
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
