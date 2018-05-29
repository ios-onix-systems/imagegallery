//
//  RegisterViewModel.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol RegisterModelType {
    var avatar: Data? { get set }
    
    func register(userForm: UserForm, completion: @escaping UserCompletionType)
}

class RegisterModel: RegisterModelType {
    private var userService: UserServiceType
    var avatar: Data?
    
    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func register(userForm: UserForm, completion: @escaping UserCompletionType) {
        userService.registerUser(userForm: userForm, completion: { result in
            
            switch result {
            case .result(let info):
                completion(.result(info))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
    deinit {
        print("RegisterViewModel - deinit")
    }
}

class RegisterModelFactory {
    static func `default`() -> RegisterModelType {
        return RegisterModel(userService: UserServiceFactory.default())
    }
}
