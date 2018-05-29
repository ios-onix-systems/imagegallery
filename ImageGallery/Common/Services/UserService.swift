//
//  UserService.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

protocol UserServiceType: Service {
    var isAuthorized: Bool { get }
    
    func loginUser(email: String, password: String, completion: @escaping UserCompletionType)
    func registerUser(userForm: UserForm, completion: @escaping UserCompletionType)
}

class UserService: UserServiceType {
    private var credentialsService = CredentialsService()
    var userProvider: UserProviderType
    
    init(userProvider: UserProviderType) {
        self.userProvider = userProvider
    }
    
    var isAuthorized: Bool {
        // Will be needed when refresh token request calls
        if credentialsService.refreshToken != nil {
            return true
        }
        
        return false
    }
    
    func loginUser(email: String, password: String, completion: @escaping UserCompletionType) {
        userProvider.login(email: email, password: password, completion: { result in
            switch result {
            case .result(let info):
                completion(.result(info))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
    func registerUser(userForm: UserForm, completion: @escaping UserCompletionType) {
        userProvider.register(userForm: userForm, completion: { result in
            switch result {
            case .result(let info):
                completion(.result(info))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
}

class UserServiceFactory {
    static func `default`() -> UserServiceType {
        return UserService(userProvider: UserProviderFactory.default())
    }
}
