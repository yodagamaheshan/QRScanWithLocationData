//
//  WebViewController.swift
//  Oldroadsoftware
//
//  Created by Heshan Yodagama on 2/17/20.
//  Copyright © 2020 Heshan Yodagama. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:"http://atrkapp-cicd.atrk.net/qrredirect.aspx?label_number=M2HFJXVUM8&ok=1&latitude=48.8328516&longitude=2.7269344&type=html")
               let myRequest = URLRequest(url: myURL!)
               webView.load(myRequest)
    }
}
