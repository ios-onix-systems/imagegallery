//
//  UserProvider.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

enum UserResult {
    case result(AuthInfo)
    case error(Error)
}

typealias UserCompletionType = (UserResult) -> ()

protocol UserProviderType {
    func register(userForm: UserForm,  completion: @escaping UserCompletionType)
    func login(email: String, password: String,  completion: @escaping UserCompletionType)
}

class UserProvider: UserProviderType {
    
    func register(userForm: UserForm, completion: @escaping UserCompletionType) {
        let request = CreateUserRequest(userForm: userForm)
        
        Alamofire.request(request.url, method: request.method, parameters: request.parameters(), encoding: request.parametersEncoding, headers: request.headers())
            .responseJSON(completionHandler: { [weak self] responce in
                guard let `self` = self else { return }
                
                switch responce.result {
                case .success( _):
                    guard let data = responce.data else { return }
                    
                    if let parsedData = try? JSONDecoder().decode(AuthInfo.self, from: data) {
                        completion(.result(parsedData))
                    } else {
                        completion(.error(NSError(domain: "Registration error", code: -1, userInfo: nil)))
                    }
                case .failure(let error):
                    completion(.error(error))
                }
            })
    }
    
    func login(email: String, password: String, completion: @escaping UserCompletionType) {
        let request = LoginRequest(email: email, password: password)
        
        Alamofire.request(request.url, method: request.method, parameters: request.parameters(), encoding: request.parametersEncoding, headers: request.headers())
            .responseJSON(completionHandler: { [weak self] responce in
                guard let `self` = self else { return }
                
                switch responce.result {
                case .success( _):
                    guard let data = responce.data else { return }
                    
                    if let parsedData = try? JSONDecoder().decode(AuthInfo.self, from: data) {
                        completion(.result(parsedData))
                    } else {
                        if let error = try? JSONDecoder().decode(APIError.self, from: data) {
                            completion(.error(NSError(domain: error.error, code: -1, userInfo: nil)))
                        } else {
                            completion(.error(NSError(domain: "Failed to login", code: -1, userInfo: nil)))
                        }
                    }
                case .failure(let error):
                    completion(.error(error))
                }
            })
    }
}


class UserProviderFactory {
    static func `default`() -> UserProviderType {
        return UserProvider()
    }
}
