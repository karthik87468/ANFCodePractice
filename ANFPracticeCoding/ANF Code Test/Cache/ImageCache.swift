//
//  ImageCache.swift
//  ANF Code Test
//
//  Created by karthik on 12/15/24.
//

import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func storeImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func retrieveImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
