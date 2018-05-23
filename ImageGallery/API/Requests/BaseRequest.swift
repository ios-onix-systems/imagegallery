//
//  BaseRequest.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseRequestType {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parametersEncoding: ParameterEncoding { get }
    
    func parameters() -> Parameters
    func headers() -> HTTPHeaders?
}

class BaseRequest: BaseRequestType {
    var baseUrl: String {
        return Defines.Server.baseUrl
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    func parameters() -> Parameters {
        return [:]
    }
    
    func headers() -> HTTPHeaders? {
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
    var parametersEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

extension BaseRequest {
    var url: URL {
        return URL(string: self.baseUrl + self.path)!
    }
}
