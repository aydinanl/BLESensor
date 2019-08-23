//
//  PeripheralViewController.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 12.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import UIKit

class PeripheralViewController: UIViewController {
    
    var peripheral: BLEPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()

        peripheral = BLEPeripheral(dataSource: DeviceAccelerometerDataSource())
    }
    
}
