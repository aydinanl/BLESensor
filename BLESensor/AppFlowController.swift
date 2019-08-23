//
//  AppFlowController.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 12.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import UIKit

class AppFlowController {
    var window = UIWindow()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        //central = BLECentral()

        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BLERoleSelectViewController") as! BLERoleSelectViewController
        viewController.onChoice = { [weak self] choice in
            let nextViewController: UIViewController
            switch choice {
            case .central:
                let viewController = DiscoveryViewController()
                viewController.onConnected = {
                    let deviceInfoViewController = DeviceInfoViewController()
                    deviceInfoViewController.central = viewController.central
                    self?.window.rootViewController = deviceInfoViewController
                }
                nextViewController = viewController

            }
            self?.window.rootViewController = nextViewController
        }
        //viewController.central = central
        window.rootViewController = viewController
        window.makeKeyAndVisible() 
    }
}
