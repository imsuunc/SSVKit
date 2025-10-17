//
//  SettingViewController.swift
//  SSVKit
//
//  Created by Suu Suu on 6/4/25.
//

import UIKit
import SSVKit

class SettingViewController: SViewController {
    
    open override func initializeNotification() {
        
    }
    
    open override func initializeViews() {
        view.backgroundColor = .purple
        view.addTapGesture {
            DispatchQueue.main.async {
                AppRouter.shared.navigate(to: MainRoute.screen, with: .push)
            }
        }
    }
    
    open override func initializeData() {
        
    }
    
}
