//
//  AuthInfo.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

class AuthInfo: Decodable {
    var creationTime: String
    var token: String
    var avatar: String
    
    enum CodingKeys: String, CodingKey {
        case creationTime = "creation_time", token, avatar
    }
    
}
