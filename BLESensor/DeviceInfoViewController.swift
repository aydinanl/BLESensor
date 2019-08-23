//
//  DeviceInfoViewController.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 14.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import UIKit

class DeviceInfoViewController: UIViewController {
    @IBOutlet weak var batteryLevelLabel: UILabel!
    
    var central: BLECentral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        central?.onDataUpdated = { [weak self] data in
            DispatchQueue.main.async {
                self?.update(data)
            }
        }
    }
    
    func update(_ data: BatteryLevelData){
        batteryLevelLabel.text = "%\(data.value)"
    }
}
