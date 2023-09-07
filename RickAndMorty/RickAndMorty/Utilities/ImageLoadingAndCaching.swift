//
//  ImageLoadingAndCaching.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import UIKit

final class ImageLoadingAndCaching {
    
    func getImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let imageDataFromCache = fetchFromCache(url: url.absoluteString) {
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
                self.saveInCache(url: url.absoluteString, data: imageData)
                completion(image)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
