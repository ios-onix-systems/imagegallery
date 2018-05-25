//
//  ImageUploadError.swift
//  ImageGallery
//
//  Created by Serhiy on 5/25/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

class ImageUploadErrror: Decodable {
    var errors: [String] = []
    
    enum RootKeys: String, CodingKey {
        case children
    }
    
    enum ChildrenKeys: String, CodingKey {
        case image, description, hashtag, latitude, longitude
    }
    
    enum ErrorKey: String, CodingKey {
        case errors
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        let childrenContainer = try container.nestedContainer(keyedBy: ChildrenKeys.self, forKey: .children)
        
        let imageContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .image)
        let descriptionContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .description)
        let hashtagContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .hashtag)
        let latitudeContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .latitude)
        let longitudeContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .longitude)
        
        if let errors = try imageContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
        if let errors = try descriptionContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
        if let errors = try hashtagContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
        if let errors = try latitudeContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
        if let errors = try longitudeContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
    }
}
