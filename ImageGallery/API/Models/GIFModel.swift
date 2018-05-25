//
//  GIFModel.swift
//  ImageGallery
//
//  Created by Serhiy on 5/25/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

class GIFModel: Decodable {
    var gif: String
    
    enum CodingKeys: String, CodingKey {
        case gif
    }
}
