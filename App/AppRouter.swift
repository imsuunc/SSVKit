//
//  AppRouter.swift
//  SSVKit
//
//  Created by Suu Suu on 6/4/25.
//

import SSVKit

class AppRouter: SSRouter {
    
    public static let shared = AppRouter()
    
    required init(with route: SRoute) {
        super.init(with: route)
    }
    
    private init() {
        super.init(with: SplashRoute.screen)
    }
    
}
