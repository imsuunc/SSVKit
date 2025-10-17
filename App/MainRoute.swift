//
//  MainRoute.swift
//  SSVKit
//
//  Created by Suu Suu on 6/4/25.
//

import UIKit
import SSVKit

enum MainRoute: SRoute {
    case screen
    
    var screen: UIViewController {
        return MainViewController()
    }
    
}
