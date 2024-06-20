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
//public enum HHDownloadState {
//    case process(_ process: Float)
//    case success(_ filePath: String)
//    case failure(_ error: Error)
//}
//
//public func jjs_download(url: String?, filename: String? = nil) -> Observable<JJSDownloadState> {
//    
//    return Observable<JJSDownloadState>.create { observer -> Disposable in
//        
//        var request: DownloadRequest?
//        
//        if let filename {
//            // 判断是否已存在，已存在则不再处理
//            let documentsURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//            let fileURL = (documentsURL! as NSString).appendingPathComponent(filename)
//            if FileManager.default.fileExists(atPath: fileURL) {
//                observer.onNext(.success(fileURL))
//                observer.onCompleted()
//            } else {
//                request = _download(url: url, filename: filename, observer: observer)
//            }
//        }
//        // 不存在，则还需要下载
//        request = _download(url: url, filename: filename, observer: observer)
//        
//        return Disposables.create {
//            request?.cancel()
//        }
//    }
//}
//
//private func _download(url: String?, filename: String?, observer: AnyObserver<JJSDownloadState>) -> DownloadRequest? {
//    
//    let destination: DownloadRequest.Destination = { _, _ in
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileURL = documentsURL.appendingPathComponent(filename!)
//        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//    }
//    
//    // 不存在，则还需要下载
//    if let url {
//        return AF.download(url, to: (filename == nil ? nil : destination))
//            .downloadProgress() { progress in
//                // 下载进度
//                observer.onNext(.process(Float(progress.fractionCompleted)))
//            }
//            .response { response in
//                // 下载
//                if let path = response.fileURL?.path, response.error == nil {
//                    observer.onNext(.success(path))
//                    observer.onCompleted()
//                    
//                } else if let error = response.error{
//                    observer.onNext(.failure(error))
//                    observer.onError(error)
//                    
//                } else {
//                    let error = NSError(domain: "下载失败", code: 1000000)
//                    observer.onNext(.failure(error))
//                    observer.onError(error)
//                    
//                }
//            }
//    } else {
//        let error = NSError(domain: "url 为空", code: 1000000)
//        observer.onNext(.failure(error))
//        observer.onError(error)
//        return nil
//    }
//}
