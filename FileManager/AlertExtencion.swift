//
//  AlertExtencion.swift
//  FileManager
//
//  Created by ln on 23.04.2023.
//

import UIKit

import UIKit

extension UIApplication {
    
    class func topViewController(
        controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

class AlertErrorSample {
    
    static let shared = AlertErrorSample()
    
    func alert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        UIApplication.topViewController()!.present(alert, animated: true)
    }
}
