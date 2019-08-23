//
//  BLEPeripheral.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 12.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEPeripheral: NSObject, CBPeripheralManagerDelegate {
    private var manager: CBPeripheralManager!
    private var characteristic: CBMutableCharacteristic!
    private let encoder = JSONEncoder()
    
    private var dataSource: AccelerometerDataSource
    
    init(dataSource: AccelerometerDataSource){
        self.dataSource = dataSource
        super.init()
        manager = CBPeripheralManager(delegate: self, queue: nil)
        self.dataSource.onUpdate = { [weak self] data in
            self?.update(with: data)
        }
        self.dataSource.start()
    }
    
    func setup() {
        let characteristicUUID = CBUUID(string: BLEIdentifiers.characteristicIdentifier)
        characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: [.read, .notify], value: nil, permissions: [.readable])
        
        let descriptor = CBMutableDescriptor(type: CBUUID(string: CBUUIDCharacteristicUserDescriptionString), value: "BLESensor prototype")
        characteristic.descriptors = [descriptor]
        
        let serviceUUID = CBUUID(string: BLEIdentifiers.serviceIdentifier)
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        service.characteristics = [characteristic]
        
        manager.add(service)
    }
    
    func update(with data: AccelerometerData){
        if let payload = try? encoder.encode(data){
            characteristic.value = payload
            manager.updateValue(payload, for: characteristic, onSubscribedCentrals: nil)
        } else {
            print("error encoding AccelerometerData ")
        }
    }
    
    //MARK: CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("peripheral is powered on")
            setup()
        }else {
            print("peripheral is not avaible: \(peripheral.state.rawValue)")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("Could not add service: \(error.localizedDescription)")
        }else{
            print("Peripheral added service. Start advertising")
            
            let adversimentData: [String: Any] = [
                CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: BLEIdentifiers.serviceIdentifier)],
                CBAdvertisementDataLocalNameKey: "BLE Sensor" // This key will not be transmitted when app is backgrounded
            ]
            manager.startAdvertising(adversimentData)
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Could not start advertising: \(error.localizedDescription)")
        }else {
            print("peripheral started advertising")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("Did recive read request: \(request)")
        if !request.characteristic.uuid.isEqual(characteristic.uuid) {
            peripheral.respond(to: request, withResult: .requestNotSupported)
        } else {
            guard let value = characteristic.value else {
                peripheral.respond(to: request, withResult: .invalidAttributeValueLength)
                return
            }
            if request.offset > value.count {
                peripheral.respond(to: request, withResult: .invalidOffset)
            } else {
                request.value = value.subdata(in: request.offset..<value.count-request.offset)
                peripheral.respond(to: request, withResult: .success)
            }
            
        }
    }
}
