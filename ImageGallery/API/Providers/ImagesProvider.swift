//
//  ImagesProvider.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

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

protocol ImagesProviderType {
    var token: AuthInfo { get }
    
    func loadImage(imageForm: ImageForm, completion: @escaping ImageCompletionType)
    func all(completion: @escaping ImagesCompletionType)
}

class ImagesProvider: ImagesProviderType {
    var token: AuthInfo
    
    init(token: AuthInfo) {
        self.token = token
    }
    
    func all(completion: @escaping ImagesCompletionType) {
        let request = GetImagesRequest(token: token.token)
        
        Alamofire.request(request.url, method: request.method, parameters: request.parameters(), encoding: request.parametersEncoding, headers: request.headers())
            .responseJSON(completionHandler: { [weak self] responce in
                guard let `self` = self else { return }
                
                switch responce.result {
                case .success(let data):
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
    
    func loadImage(imageForm: ImageForm, completion: @escaping ImageCompletionType) {
        let request = AddImageRequest(token: token.token, imageData: imageForm)
        
        
    }
    
}

class ImagesProviderFactory {
    static func `default`(token: AuthInfo) -> ImagesProviderType {
        return ImagesProvider(token: token)
    }
}
