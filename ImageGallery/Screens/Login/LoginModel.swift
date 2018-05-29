//
//  LoginViewModel.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol LoginModelType {
    func confirmLogin(email: String, password: String, completion: @escaping UserCompletionType)
}

class LoginModel: LoginModelType {
    private var userService: UserServiceType
    
    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func confirmLogin(email: String, password: String, completion: @escaping UserCompletionType) {
        userService.loginUser(email: email, password: password, completion: { result in
            switch result {
            case .result(let info):
                completion(.result(info))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
    deinit {
        print("LoginModel - deinit")
    }
}

class LoginModelFactory {
    static func `default`() -> LoginModelType {
        return LoginModel(userService: UserServiceFactory.default())
    }
    
}
