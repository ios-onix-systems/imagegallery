//
//  CreateGIF.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

class GetGifRequest: BaseRequest {
    private var token: String
    
    override func headers() -> HTTPHeaders? {
        return [
            "Content-Type":"application/x-www-form-urlencoded",
            "token": self.token]
    }
    
    override func parameters() -> Parameters {
        return ["format": "json"]
    }
    
    override var parametersEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    override var path: String {
        return "/gif"
    }
    
    init(token: String) {
        self.token = token
    }
}
