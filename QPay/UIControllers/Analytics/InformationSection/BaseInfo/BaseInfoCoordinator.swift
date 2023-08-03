//
//  BaseInfoCoordinator.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class BaseInfoCoordinator {
    
    var navigationController: UINavigationController
    var configuration: BaseInfoConfiguration
    
    init(navigationController: UINavigationController, configuration: BaseInfoConfiguration) {
        self.navigationController = navigationController
        self.configuration = configuration
    }
    
    func start() {
        let controller = self.navigationController.getStoryboardView(BaseInfoFavoritesViewController.self)
        controller.configuration = self.configuration
        self.navigationController.pushViewController(controller, animated: true)
    }
}
