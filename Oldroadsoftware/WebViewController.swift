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
    var lat: String?
    var long: String?
    var baseURL: String?
    var labelNumber: String?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let myURL = URL(string:"http://atrkapp-cicd.atrk.net/qrredirect.aspx?label_number=M2HFJXVUM8&ok=1&latitude=48.8328516&longitude=2.7269344&type=html")
               let myRequest = URLRequest(url: myURL!)
               webView.load(myRequest)
    }
    
    func getURL(baseUrlString: String,with labelNumber:String, latiyude lat: String,and lon: String) -> URL?{
        let pathOne = "qrredirect.aspx"
        let labelNumber = URLQueryItem(name: "label_number" , value: labelNumber)
        let ok = URLQueryItem(name: "ok", value: "1")
        let lat = URLQueryItem(name: "latitude", value: lat)
        let lon = URLQueryItem(name: "longitude", value: lon)
        let type = URLQueryItem(name: "type", value: "html")
        
        var urlComponnent = URLComponents(string: baseUrlString)
        urlComponnent?.path = pathOne
        urlComponnent?.queryItems = [labelNumber,ok,lat,lon,type]
        return urlComponnent?.url
    }
}
extension WebViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
