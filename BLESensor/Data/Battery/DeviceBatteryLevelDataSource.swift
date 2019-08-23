//
//  DeviceBatteryLevelDataSource.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 14.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import Foundation

class DeviceBatteryLevelDataSource: BatteryLevelDataSource {
    
    var onUpdate: ((BatteryLevelData) -> Void)?
        
    func start() {

    }
    
    func stop() {
        
    }
    
}
