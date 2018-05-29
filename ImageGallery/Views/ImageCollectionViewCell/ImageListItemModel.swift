//
//  ImageListItemModel.swift
//  ImageGallery
//
//  Created by Serhiy on 5/29/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

enum UImageResult {
    case result(UIImage)
    case error(Error)
}

typealias UIImageCompletionType = (UImageResult) -> ()

protocol ImageListItemModelType {
    var address: String? { get }
    var weather: String { get }
    var image: UIImage? { get }
    var imageUrl: String { get }
    
    func loadImage(completion: @escaping UIImageCompletionType)
}

class ImageListItemModel: ImageListItemModelType {
    var address: String?
    var weather: String
    var image: UIImage?
    var imageUrl: String
    
    init(with model: Image) {
        self.address = model.address
        self.weather = model.weather ?? ""
        self.imageUrl = model.bigImagePath ?? ""
    }
    
    func loadImage(completion: @escaping UIImageCompletionType) {
        if let image = image {
            completion(.result(image))
            return
        }
        
        ImageLoader.loadImage(imageUrl: imageUrl, completion: { result in
            switch result {
            case .result(let image):
                completion(.result(image))
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}
