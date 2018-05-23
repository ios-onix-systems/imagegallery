//
//  RegistrationError.swift
//  ImageGallery
//
//  Created by Serhiy on 5/23/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

class RegistratinoError: Decodable {
    var userName: String?
    var email: String?
    var password: String?
    var avatar: String?
    
    enum RootKeys: String, CodingKey {
        case children
    }
    
    enum ChildrenKeys: String, CodingKey {
        case username, email, password, avatar
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
    }
}
