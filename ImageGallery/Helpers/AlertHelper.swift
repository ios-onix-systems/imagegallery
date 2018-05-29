//
//  AlertHelper.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    class func showAlert(_ error: String) {
        
        if let root = UIApplication.shared.keyWindow?.rootViewController {
            let alertVC = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alertVC.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(ok)
            root.present(alertVC, animated: true, completion: nil)
        }
    }
    
    class func showMessage(_ message: String) {
        HUDRenderer.hideHUD()
        
        if let root = UIApplication.shared.keyWindow?.rootViewController {
            let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alertVC.dismiss(animated: true, completion: nil)
            })
            
            alertVC.addAction(ok)
            root.present(alertVC, animated: true, completion: nil)
        }
    }
}
