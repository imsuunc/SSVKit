//
//  MainViewController.swift
//  SSVKit
//
//  Created by Suu Suu on 6/4/25.
//

import UIKit
import SSVKit

class MainViewController: SViewController {
    
    open override func initializeNotification() {
        
    }
    
    open override func initializeViews() {
        view.backgroundColor = .yellow
        view.addTapGesture {
            DispatchQueue.main.async {
                AppRouter.shared.navigate(to: SplashRoute.screen, with: .root)
            }
        }
    }
    
    open override func initializeData() {
        
    }
    
}
