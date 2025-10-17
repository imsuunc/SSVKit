//
//  ViewController.swift
//  SSVKit
//
//  Created by Suu Suu on 22/3/25.
//

import UIKit
import SSVKit

class SplashViewController: SViewController {

    open override func initializeNotification() {
        
    }
    
    open override func initializeViews() {
        view.backgroundColor = .blue
        view.addTapGesture {
            DispatchQueue.main.async {
                AppRouter.shared.navigate(to: HomeRoute.screen, with: .present())
            }
        }
    }
    
    open override func initializeData() {
        
    }

}

