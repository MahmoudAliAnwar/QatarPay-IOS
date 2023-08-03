//
//  QRScannerViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/9/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import AVFoundation
import QKMRZScanner

class PassportScannerViewController: ViewController, QKMRZScannerViewDelegate {
    
    @IBOutlet weak var scannerView: QKMRZScannerView!
    
    var updateViewElementDelegate: UpdateViewElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.scannerView.startScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.scannerView.stopScanning()
    }
    
    func mrzScannerView(_ mrzScannerView: QKMRZScannerView, didFind scanResult: QKMRZScanResult) {
//        print(scanResult.documentNumber)
        
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: true, data: scanResult)
        self.dismiss(animated: true) {
            
        }
    }
}
