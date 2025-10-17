//
//  SettingRoute.swift
//  SSVKit
//
//  Created by Suu Suu on 6/4/25.
//

import UIKit
import SSVKit

enum SettingRoute: SRoute {
    case screen
    
    var screen: UIViewController {
        switch self {
        case .screen:
            return SettingViewController()
        }
    }
}
