//
//  ShowGifModel.swift
//  ImageGallery
//
//  Created by Serhiy on 5/25/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol ShowGifModelType {
    func loadGifUrl(completion: @escaping GIFCompletionType)
    func loadGif(url: String, completion: @escaping UIImageCompletionType)
}

class ShowGifModel: ShowGifModelType {
    private var imagesProvider: ImagesProviderType
    
    init(with provider: ImagesProviderType) {
        self.imagesProvider = provider
    }
    
    func loadGifUrl(completion: @escaping GIFCompletionType) {
        self.imagesProvider.getGif(completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let model):
                completion(.result(model))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
    func loadGif(url: String, completion: @escaping UIImageCompletionType) {
        ImageLoader.loadImage(imageUrl: url, completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let image):
                completion(.result(image))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
}

class ShowGifModelFactory {
    static func `default`(provider: ImagesProviderType) -> ShowGifModelType {
        return ShowGifModel(with: provider)
    }
}
