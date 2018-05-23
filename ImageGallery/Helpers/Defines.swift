//
//  Defines.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

struct Defines {
    
    struct Server {
        
        fileprivate static let DEV_INSTANCE   = "http://api.doitserver.in.ua"
        fileprivate static let LIVE_INSTANCE  = ""
        
        static let apiUrl = LIVE_INSTANCE
        static let clientId = "2"
        static let clientSecret = "5SrwTSYW7gmSATE6jui2JXrkNCXbeABiByHQ1PLc"
        static let baseUrl = DEV_INSTANCE
    }
    
    struct Sizes {
        static let imagesCollectionViewHeight = 80
    }
}

