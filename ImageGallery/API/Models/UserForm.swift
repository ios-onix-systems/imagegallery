//
//  UserForm.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol UserFormType {
    var userName: String? { get }
    var email: String { get }
    var password: String { get }
    var avatar: Data { get }
}

class UserForm: UserFormType {
    var userName: String?
    var email: String
    var password: String
    var avatar: Data
    
    init(userName: String?, email: String, password: String, avatar: Data) {
        self.userName = userName
        self.email = email
        self.password = password
        self.avatar = avatar
    }

}
