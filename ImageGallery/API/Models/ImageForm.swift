//
//  ImageForm.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol ImageFormType {
    var image: Data { get }
    var description: String? { get }
    var hashtag: String? { get }
    var latitude: Float { get }
    var longitude: Float { get }
}

class ImageForm: ImageFormType, Decodable {
    var image: Data
    var description: String?
    var hashtag: String?
    var latitude: Float
    var longitude: Float
    
    init(image: Data, description: String?, hashtag: String?, latitude: Float, longitude: Float) {
        self.image = image
        self.description = description
        self.hashtag = hashtag
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
