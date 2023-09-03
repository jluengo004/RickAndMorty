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
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(RMResult.failure(error.localizedDescription))
            }
            
            if let data = data {
                completion(RMResult.success(data))
            }
        }
        task.resume()
    }
}
