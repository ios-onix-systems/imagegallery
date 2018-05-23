//
//  CredentialsService.swift
//  TestTask
//
//  Created by Serhiy on 5/21/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

public final class CredentialsService {
    
    fileprivate struct StoredCredentialsKeys {
        static let kAuthTokenKey = "refreshToken"
    }
    
    var refreshToken: String? {
        if let token = UserDefaults.standard.string(forKey: StoredCredentialsKeys.kAuthTokenKey) {
            return token
        }
        
        return nil
    }
    
    func save(_ refreshToken: String) {
        UserDefaults.standard.set(refreshToken, forKey: StoredCredentialsKeys.kAuthTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: StoredCredentialsKeys.kAuthTokenKey)
        UserDefaults.standard.synchronize()
    }
}
