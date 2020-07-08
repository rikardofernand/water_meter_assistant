//
//  AlertService.swift
//  WaterMetteringAssist
//
//  Created by user157929 on 1/13/20.
//  Copyright © 2020 Ric. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    class func alert(messageString: String, vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: messageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
        
    }
    
}

