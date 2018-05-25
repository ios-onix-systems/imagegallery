//
//  RegistrationErrors.swift
//  ImageGallery
//
//  Created by Serhiy on 5/25/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

class RegistrationErrors: Decodable {
    var errors: [String] = []
    
    enum RootKeys: String, CodingKey {
        case children
    }
    
    enum ChildrenKeys: String, CodingKey {
        case username, password, email, avatar
    }
    
    enum ErrorKey: String, CodingKey {
        case errors
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        let childrenContainer = try container.nestedContainer(keyedBy: ChildrenKeys.self, forKey: .children)
        
        let emailContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .email)
        let passwordContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .password)
        let usernameContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .username)
        let avatarContainer = try childrenContainer.nestedContainer(keyedBy: ErrorKey.self, forKey: .avatar)
        
        if let errors = try emailContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
        if let errors = try passwordContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
        if let errors = try usernameContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
        
        if let errors = try avatarContainer.decodeIfPresent([String].self, forKey: .errors) {
            self.errors.append(contentsOf: errors)
        }
        
    }
}
