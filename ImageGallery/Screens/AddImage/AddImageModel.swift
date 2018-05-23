//
//  AddImageViewModel.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol AddImageModelType {
    var imageData: Data? { get set }
    
    func uploadImage(imageForm: ImageForm, completion: @escaping ImageCompletionType)
}

class AddImageModel: AddImageModelType {
    var imagesProvider: ImagesProviderType
    var imageData: Data?
    
    init(imagesProvider: ImagesProviderType) {
        self.imagesProvider = imagesProvider
    }
    
    func uploadImage(imageForm: ImageForm, completion: @escaping ImageCompletionType) {
        imagesProvider.loadImage(imageForm: imageForm, completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let image):
                completion(.result(image))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
    deinit {
        print("AddImageViewModel - deinit")
    }
}

class AddImageModelFactory {
    static func `default`(provider: ImagesProviderType) -> AddImageModel {
        return AddImageModel(imagesProvider: provider)
    }
}
