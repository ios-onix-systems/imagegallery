//
//  ImagesList.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

class ImagesList: Decodable {
    var images: [Image]
    
    enum CodingKeys: String, CodingKey {
        case images
    }
}
