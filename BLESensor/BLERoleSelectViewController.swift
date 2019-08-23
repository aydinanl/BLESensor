//
//  BLERoleSelectViewController.swift
//  BLESensor
//
//  Created by Aydın Anlıaçık on 13.08.2019.
//  Copyright © 2019 Aydın Anlıaçık. All rights reserved.
//

import UIKit

enum BLERole {
    case central
}

class BLERoleSelectViewController: UIViewController {

    var onChoice: ((BLERole) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectCentral(_ sender: Any) {
        onChoice?(.central)
    }
}
