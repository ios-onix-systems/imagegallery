//
//  CreateUser.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

class CreateUserRequest: BaseRequest {
    private var userForm: UserForm
    
    override var path: String {
        return "/create"
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var parametersEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    override func parameters() -> Parameters {
        var parameters = Parameters()
        
        if let userName = userForm.userName {
            parameters["username"] = userName
        }
        
        parameters["email"] = userForm.email
        parameters["password"] = userForm.password
        parameters["avatar"] = userForm.avatar
        
        return parameters
    }
    
    init(userForm: UserForm) {
        self.userForm = userForm
    }
    
}
