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
    var lastBaseUrl: String?
    var lastLabelNumber: String?
    var lastLon: String?
    var lastLat: String?
    
    var moveToWebAfterGettingLocationData: Bool = true
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        didHaveToAskUserForPermisionTogetLocationDataIfUserHaventAllow()
            locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeLastVAlues()
    }
        
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = true
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = true
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBAction func scanAction(_ sender: Any) {
        moveToWebAfterGettingLocationData = true
        readerVC.delegate = self
        locationManager.startUpdatingLocation()
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    func removeLastVAlues(){
        lastLat = nil
        lastLon = nil
        lastBaseUrl = nil
        lastLabelNumber = nil
    }
    
    func didHaveToAskUserForPermisionTogetLocationDataIfUserHaventAllow() -> Bool{
        if CLLocationManager.locationServicesEnabled(){
            
            if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == .authorizedAlways){
                return false
            }
            else{
                locationManager.requestWhenInUseAuthorization()
            }
        }
        else{
            self.showAllert(with: "Location Services", and: "Enable the Location Services switch in Settings > Privacy")
        }
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
        let  value = result.value
        if self.validateData(data: value){
            
            let data = self.getData(from: value)
            let baseUrl = data[0]
            let labelNumber = data[1]
            if self.lastLat != nil, self.lastLon != nil{
                self.goToWebView(with: baseUrl, labelNumber: labelNumber, lat: self.lastLat! , lon: self.lastLon!)
            }
            else{
                reader.stopScanning()
                dismiss(animated: true) {
                    if !self.didHaveToAskUserForPermisionTogetLocationDataIfUserHaventAllow(){
                        let alert = UIAlertController(title: "Hold on!", message: "You will be direct to web automatically, after getting location data...", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                            self.moveToWebAfterGettingLocationData = false
                            self.locationManager.stopUpdatingLocation()
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                
                    
                }
            }
        }
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        locationManager.stopUpdatingLocation()
        removeLastVAlues()
        
    }
}

extension SplachViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLon = String(Double((locations.last?.coordinate.latitude)!))
        lastLat = String(Double((locations.last?.coordinate.longitude)!))
        if moveToWebAfterGettingLocationData, lastBaseUrl != nil, lastLabelNumber != nil{
            goToWebView(with: lastBaseUrl!, labelNumber: lastLabelNumber!, lat: lastLat!, lon: lastLon!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAllert(with: "Location", and: "Error with getting location data")
    }
}

//TODO:use this --locationManager.stopUpdatingLocation()-- when user dissmis QR
