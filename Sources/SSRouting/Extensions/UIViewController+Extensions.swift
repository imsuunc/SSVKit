//
//  UIViewController+Extensions.swift
//  SSVKit
//
//  Created by Suu Suu on 29/10/25.
//

import UIKit

extension UIViewController {
    
    func exit(_ completion: (() -> Void)? = nil) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.first != self {
                navigationController.popViewController(animated: true)
                completion?()
            } else {
                navigationController.dismiss(animated: true, completion: completion)
            }
        } else if presentingViewController != nil {
            dismiss(animated: true, completion: completion)
        } else {
            completion?()
        }
    }
    
}
