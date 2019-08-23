//
//  DiscoveredPeripheral.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 12.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import Foundation
import CoreBluetooth

class DiscoveredPeripheral {
    var peripheral: CBPeripheral
    var rssi: NSNumber
    var adversimentData: [String: Any]
    
    init(peripheral: CBPeripheral, rssi: NSNumber, adversimentData: [String: Any]) {
        self.peripheral = peripheral
        self.rssi = rssi
        self.adversimentData = adversimentData
    }
}
