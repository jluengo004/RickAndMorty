//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 3/9/23.
//

import Foundation

public enum RMResult<Response, ErrorModel>{
    case success(Response)
    case failure(ErrorModel)
}

public class NetworkManager {
    public func httpGet(url: URL, completion: @escaping (RMResult<Data, String>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let cache = RealmManager()
        cache.fetchAllObjects()
        if let dataCache = fetchFromCache(url: url.absoluteString) {
            completion(RMResult.success(dataCache))
        } else {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(RMResult.failure(error.localizedDescription))
                }
                
                if let data = data {
                    self.saveInCache(url: url.absoluteString, data: data)
                    completion(RMResult.success(data))
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
