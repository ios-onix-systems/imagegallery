//
//  AddImage.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import Alamofire

class AddImageRequest: BaseRequest {
    private var imageForm: ImageFormType
    private var token: String
    
    override var path: String {
        return "/image"
    }
    
    override func headers() -> HTTPHeaders? {
        return [
            "Content-type": "multipart/form-data",
            "token": token]
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override func parameters() -> Parameters {
        var parameters = Parameters()
        
        parameters["_format"] = "json"
        //parameters["image"] = imageForm.image
        
        if let description = imageForm.description {
            parameters["description"] = description
        }
        
        if let hashtag = imageForm.hashtag {
            parameters["hashtag"] = hashtag
        }
        
        parameters["latitude"] = imageForm.latitude
        parameters["longitude"] = imageForm.longitude
        
        return parameters
    }
    
    init(token: String, imageData: ImageFormType) {
        self.imageForm = imageData
        self.token = token
    }
}
