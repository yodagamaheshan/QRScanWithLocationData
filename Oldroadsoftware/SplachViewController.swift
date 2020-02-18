//
//  SplachViewController.swift
//  Oldroadsoftware
//
//  Created by Heshan Yodagama on 2/17/20.
//  Copyright © 2020 Heshan Yodagama. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import CoreLocation

class SplachViewController: UIViewController {
    
    var lon: String?
    var lat: String?
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        lon = nil
        lat = nil
    }
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = true
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBAction func scanAction(_ sender: Any) {
        

        if canGetLocation(){
            locationManager.requestLocation()
        }
        
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let  value = result?.value, self.validateData(data: value){
                let data = self.getData(from: value)
                let baseUrl = data[0]
                let labelNumber = data[1]
                self.goToWebView(with: baseUrl, labelNumber: labelNumber, lat: "48.8328516", lon: "2.7269344 ")
            }
            
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    //TODO: implement these methods
    func canGetLocation() -> Bool{
        return true
    }
    
    func generateAppropriateMessageAboutLocation(){
        
    }
    
    func getData(from scanedData: String) ->[String] {
      return scanedData.components(separatedBy: "c/")
    }
    
    func goToWebView(with baseURL: String, labelNumber: String, lat: String, lon: String){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: WebViewController.self)) as! WebViewController
        vc.baseURL = baseURL
        vc.labelNumber = labelNumber
        vc.lat = lat
        vc.lon = lon
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func validateData(data: String) -> Bool{
        
        if !data.contains("/c/") || getData(from: data).count != 2 {
            return false
        }
        
        return true
    }
}

extension SplachViewController: QRCodeReaderViewControllerDelegate{
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)

    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        locationManager.stopUpdatingLocation()
        lon = nil
        lat = nil
    }
}

extension SplachViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lat = String(Double((locations.last?.coordinate.latitude)!))
        lon = String(Double((locations.last?.coordinate.longitude)!))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

//TODO:use this --locationManager.stopUpdatingLocation()-- when user dissmis QR
