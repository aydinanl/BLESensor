//
//  DiscoveryViewController.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 12.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import UIKit

class DiscoveryViewController: UITableViewController {
    
    var central: BLECentral!
    var onConnected: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        central = BLECentral()
        central.onDiscovered = { [weak self] in
            self?.tableView.reloadData()
        }
        central?.onConnected = { [weak self] in
            self?.onConnected?()
        }
        
        tableView.register(UINib(nibName: "DiscoveredPeripheralCell", bundle: nil), forCellReuseIdentifier: "DiscoveredPeripheralCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return central.discoveradPeripherals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveredPeripheralCell", for: indexPath) as! DiscoveredPeripheralCell
        let discoveredPeripheral = central.discoveradPeripherals[indexPath.row]
        cell.identifierLabel.text = discoveredPeripheral.peripheral.name //discoveredPeripheral.peripheral.identifier.uuidString
        cell.rssiLabel.text = discoveredPeripheral.rssi.stringValue
        cell.adversimentLabel.text = discoveredPeripheral.adversimentData.debugDescription
        
        cell.identifierLabel.textColor = .blue
        cell.rssiLabel.textColor = .red
        
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        central.connect(at: indexPath.row)
    }

}
