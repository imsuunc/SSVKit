//
//  HomeRoute.swift
//  SSVKit
//
//  Created by Suu Suu on 6/4/25.
//

import SSVKit
import UIKit

enum HomeRoute: SRoute {
    case screen
    
    var screen: UIViewController {
        return HomeViewController()
    }
}
