//
//  HUDRenderer.swift
//  Tututu
//

import MBProgressHUD

class HUDRenderer {
    
    class func showHUD() {
        guard let view = UIApplication.shared.keyWindow else { return }
        MBProgressHUD.hide(for: view, animated: false)
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    class func hideHUD(){
        guard let view = UIApplication.shared.keyWindow else { return }
        MBProgressHUD.hide(for: view, animated: true)
    }
}
