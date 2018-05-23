//
//  Login.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

class LoginRequest: BaseRequest {
    private var email: String
    private var password: String
    
    override var path: String {
        return "/login"
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var parametersEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    override func parameters() -> Parameters {
        var parameters = Parameters()
        
        parameters["email"] = email
        parameters["password"] = password
        
        return parameters
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
}
