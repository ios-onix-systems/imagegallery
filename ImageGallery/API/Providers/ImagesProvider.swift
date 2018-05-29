//
//  ImagesProvider.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

enum GIFResult {
    case result(GIFModel)
    case error(Error)
}

enum ImageResult {
    case result(Image)
    case error(Error)
}

enum ImagesResult {
    case result([Image])
    case error(Error)
}

typealias ImageCompletionType = (ImageResult) -> ()
typealias ImagesCompletionType = (ImagesResult) -> ()
typealias GIFCompletionType = (GIFResult) -> ()

protocol ImagesProviderType {
    var token: AuthInfo { get }
    
    func uploadImage(imageForm: ImageForm, completion: @escaping ImageCompletionType)
    func all(completion: @escaping ImagesCompletionType)
    func getGif(completion: @escaping GIFCompletionType)
}

class ImagesProvider: ImagesProviderType {
    var token: AuthInfo
    
    init(token: AuthInfo) {
        self.token = token
    }
    
    func all(completion: @escaping ImagesCompletionType) {
        let request = GetImagesRequest(token: token.token)
        
        Alamofire.request(request.url, method: request.method, parameters: request.parameters(), encoding: request.parametersEncoding, headers: request.headers())
            .responseJSON(completionHandler: { responce in
                switch responce.result {
                case .success:
                    guard let data = responce.data else { return }
                    
                    if let parsedData = try? JSONDecoder().decode(ImagesList.self, from: data) {
                        completion(.result(parsedData.images))
                    } else {
                        completion(.error(NSError(domain: "Error", code: -1, userInfo: nil)))
                    }
                case .failure(let error):
                    completion(.error(error))
                }
            })
    }
    
    func uploadImage(imageForm: ImageForm, completion: @escaping ImageCompletionType) {
        let request = AddImageRequest(token: token.token, imageData: imageForm)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageForm.image, withName: "image", fileName: "image.png", mimeType: "image/png")
            
            for (key, value) in request.parameters() {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
        }, usingThreshold: UInt64.init(), to: request.url, method: request.method, headers: request.headers()) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard let data = response.data else { return }
                    
                    if let parsedData = try? JSONDecoder().decode(Image.self, from: data) {
                        completion(.result(parsedData))
                    } else {
                        if let error = try? JSONDecoder().decode(ImageUploadErrror.self, from: data) {
                            completion(.error(NSError(domain: error.errors.joined(separator: ","), code: -1, userInfo: nil)))
                        } else {
                            completion(.error(NSError(domain: "Error", code: -1, userInfo: nil)))
                        }
                        completion(.error(NSError(domain: "Error", code: -1, userInfo: nil)))
                    }
                    
                    if let err = response.error{
                        completion(.error(err))
                    }
                }
            case .failure(let error):
                completion(.error(NSError(domain: error.localizedDescription, code: -1, userInfo: nil)))
            }
        }
    }
    
    func getGif(completion: @escaping GIFCompletionType) {
        let request = GetGifRequest(token: token.token)
        
        Alamofire.request(request.url, method: request.method, parameters: request.parameters(), encoding: request.parametersEncoding, headers: request.headers())
            .responseJSON(completionHandler: { responce in
                
                switch responce.result {
                case .success:
                    guard let data = responce.data else { return }
                    
                    if let parsedData = try? JSONDecoder().decode(GIFModel.self, from: data) {
                        completion(.result(parsedData))
                    } else {
                        completion(.error(NSError(domain: "Error", code: -1, userInfo: nil)))
                    }
                case .failure(let error):
                    
                    completion(.error(error))
                }
            })
    }
    
}

class ImagesProviderFactory {
    static func `default`(token: AuthInfo) -> ImagesProviderType {
        return ImagesProvider(token: token)
    }
}
