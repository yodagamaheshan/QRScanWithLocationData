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
        var alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
