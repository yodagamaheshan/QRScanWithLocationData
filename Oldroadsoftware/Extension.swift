//
//  Extension.swift
//  Oldroadsoftware
//
//  Created by Heshan Yodagama on 2/18/20.
//  Copyright © 2020 Heshan Yodagama. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showAllert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
