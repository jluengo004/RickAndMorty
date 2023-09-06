//
//  ImageLoadingAndCaching.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//

import Foundation
import UIKit

final class ImageLoadingAndCaching {
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        getData(from: url) { imageData, response, error in
            guard let imageData = imageData, error == nil else { return }
            if let image = UIImage(data: imageData) {
                self.imageCache.setObject(image, forKey: url as AnyObject)
                completion(image)
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(imageFromCache)
        } else {
            downloadImage(from: url) { image in
                completion(image)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
