//
//  AllImagesViewModel.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol AllImagesModelType {
    var imagesProvider: ImagesProviderType { get }
    var imageModels: [ImageListItemModelType] { get }
    
    func getImages(completion: @escaping ImagesCompletionType )
}

class AllImagesModel: AllImagesModelType {
    var imagesProvider: ImagesProviderType
    var imageModels: [ImageListItemModelType] = []
    
    init(with provider: ImagesProviderType) {
        self.imagesProvider = provider
    }
    
    func getImages(completion: @escaping ImagesCompletionType ) {
        imagesProvider.all(completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let images):
                self.createModel(with: images)
                completion(.result(images))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
    func createModel(with images: [Image]) {
        imageModels.removeAll()
        
        for image in images {
            let imageModel = ImageListItemModel(with: image)
            self.imageModels.append(imageModel)
        }
    }
    
    deinit {
        print("AllImagesViewModel - deinit")
    }
}

class AllImagesFactory {
    static func `default`(token: AuthInfo) -> AllImagesModel {
        return AllImagesModel(with: ImagesProvider(token: token))
    }
}
