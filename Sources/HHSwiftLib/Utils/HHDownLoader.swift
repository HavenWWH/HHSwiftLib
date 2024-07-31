//
//  HHDownLoader.swift
//  HHSwiftLib
//
//  Created by 王老鹰2 on 2024/6/19.
//

import Foundation

public class HHDownLoader {
    
    public class func downloadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to download image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Failed to convert data to image")
                completion(nil)
            }
        }.resume()
    }
}


