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

class SplachViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        // Retrieve the QRCode content
         // By using the delegate pattern
         readerVC.delegate = self

         // Or by using the closure pattern
         readerVC.completionBlock = { (result: QRCodeReaderResult?) in
           print(result)
         }

         // Presents the readerVC as modal form sheet
         readerVC.modalPresentationStyle = .formSheet
        
         present(readerVC, animated: true, completion: nil)
    }
    
}

extension SplachViewController: QRCodeReaderViewControllerDelegate{
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        
    }
    
    
}
