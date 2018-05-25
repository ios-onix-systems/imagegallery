//
//  ImageHelper.swift
//  ImageGallery
//
//  Created by Serhiy on 5/25/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

class ImageLoader {
    class func loadImage(imageUrl: String, completion: @escaping UIImageCompletionType) {
        Alamofire.request(imageUrl).responseImage { response in
            if let image = response.result.value {
                completion(.result(image))
            } else {
                if let error = response.error {
                    completion(.error(error))
                }
            }
        }
    }
}
