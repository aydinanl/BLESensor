//
//  BatteryLevelDataSource.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 14.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import Foundation

struct BatteryLevelData:Codable {
    let value: Int32
}

protocol BatteryLevelDataSource {
    var onUpdate: ((BatteryLevelData)-> Void)? { get set }
    
    func start()
    func stop()
}
