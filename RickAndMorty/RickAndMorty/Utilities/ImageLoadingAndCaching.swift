//
//  ImageLoadingAndCaching.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import UIKit

final class ImageLoadingAndCaching {
    private let networkManager = NetworkManager()
    
    func getImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let imageDataFromCache = networkManager.fetchFromCache(url: url.absoluteString) {
            if let imageFromCache = UIImage(data: imageDataFromCache) {
                completion(imageFromCache)
            }
        } else {
            downloadImage(from: url) { image in
                completion(image)
            }
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        getData(from: url) { imageData, response, error in
            guard let imageData = imageData, error == nil else { return }
            if let image = UIImage(data: imageData) {
                self.networkManager.saveInCache(url: url.absoluteString, data: imageData)
                completion(image)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
