//
//  BLECentral.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 12.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLECentral:NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var manager: CBCentralManager!
    //Read-only
    private(set) var discoveradPeripherals = [DiscoveredPeripheral]()
    private var connectedPeripheral: CBPeripheral?
    private let decoder = JSONDecoder()
    
    var onDiscovered: (() -> Void)?
    var onDataUpdated: ((BatteryLevelData) -> Void)?
    var onConnected: (() -> Void)?
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil )
    }
    
    func scanForPeripherals() {
        let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        manager.scanForPeripherals(withServices: nil, options: options)
    }
    
    func connect(at index:Int) {
        guard index >= 0, index < discoveradPeripherals.count else { return }
        
        //Stop scanning when connected due to preserve battery life and free up bluetooth radio to manage connections.
        manager.stopScan()
        manager.connect(discoveradPeripherals[index].peripheral, options: nil)
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("central is powered on")
            scanForPeripherals()
        }else {
            print("central is unavaible \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let existingPeripheral = discoveradPeripherals.first(where: {$0.peripheral == peripheral}) {
            existingPeripheral.adversimentData = advertisementData
            existingPeripheral.rssi = RSSI
        }else{
            discoveradPeripherals.append(DiscoveredPeripheral(peripheral: peripheral, rssi: RSSI, adversimentData: advertisementData))
        }
        
        onDiscovered?()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("central did connect")
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        connectedPeripheral?.discoverServices([CBUUID(string: BLEIdentifiers.serviceIdentifier)]) // nil for discover all possible services
        
        onConnected?()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("central did fail to connect")
    }
    
    // MARK: - CBPeripheralDelage
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("peripheral failed to discover services: \(error.localizedDescription)")
        }else {
            peripheral.services?.forEach({ (service) in
                print("service discovered \(service)")
                peripheral.discoverCharacteristics([CBUUID(string: BLEIdentifiers.characteristicIdentifier)], for: service)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("peripheral failed to discover characteristic \(error.localizedDescription)")
        }else {
            service.characteristics?.forEach({ (characteristics) in
                print("characteristic discovered \(characteristics)")
                if characteristics.properties.contains(.read){
                    peripheral.readValue(for: characteristics)
                }
                
                peripheral.discoverDescriptors(for: characteristics)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("peripheral failed to discover descriptor \(error.localizedDescription)")
        }else {
            characteristic.descriptors?.forEach({ (descriptor) in
                print("descriptor dicovered: \(descriptor)")
                peripheral.readValue(for: descriptor)
            })
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("peripheral error updating value for characteristic: \(error.localizedDescription)")
        } else {
            print("descriptor value updated: \(characteristic)")
            if let value = characteristic.value {
                let batteryLevel: Int32 = Int32(bitPattern: UInt32([UInt8](value)[0]))
                print("Battery level: %\(batteryLevel)")
                
                let batteryLevelData = BatteryLevelData(value: batteryLevel)
                onDataUpdated?(batteryLevelData)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        if let error = error {
            print("peripheral error updating value for descriptor: \(error.localizedDescription)")
        } else {
            print("descriptor value updated: \(descriptor)")
        }
    }
}
