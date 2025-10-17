//
//  HomeViewController.swift
//  SSVKit
//
//  Created by Suu Suu on 22/3/25.
//

import UIKit
import SSVKit
import Combine

class HomeViewController: SViewController {
    
    private var bag: Set<AnyCancellable> = []

    open override func initializeNotification() {
        
    }
    
    open override func initializeViews() {
        view.backgroundColor = .red
        view.addTapGesture {
            DispatchQueue.main.async {
                AppRouter.shared.navigate(to: SettingRoute.screen, with: .present())
            }
        }
        Task {
            defer {
                print("Finally")
            }
            do {
                print("Fetch Data")
                try await Task.sleep(nanoseconds: 3 * NSEC_PER_SEC)
                throw NSError(domain: "100", code: 100, userInfo: [NSLocalizedDescriptionKey: "Hello"])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    open override func initializeData() {
        
    }

}

