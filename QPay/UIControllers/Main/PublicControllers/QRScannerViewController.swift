//
//  QRScannerViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/9/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: ViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    
    var updateElementDelegate: UpdateViewElement?
    var metadataTypes: [AVMetadataObject.ObjectType]?
    var isVendexView: Bool = false
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var overlay: UIView = UIView()
    private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.changeStatusBarBG(color: .appBackgroundColor)
        self.changeStatusBarBG(color: .clear)
        
        self.setIsVendexView(self.isVendexView)
        self.imagePicker.delegate = self
        
        self.view.backgroundColor = .black
        self.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = self.metadataTypes ?? [.qr]
        } else {
            failed()
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.cameraView.layer.addSublayer(previewLayer)
//        self.addTransparentOverlayWithCirlce()
        
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.previewLayer != nil {
            self.previewLayer.frame = self.cameraView.bounds
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: - ACTIONS

extension QRScannerViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gelleryAction(_ sender: UIButton) {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension QRScannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        guard let features = image.detectQRCode(), !features.isEmpty else {
            self.showErrorMessage("QR-code invalid, please try again")
            return
        }
        // print out the image size as a test
//        print(image.size)
        
        for case let row as CIQRCodeFeature in features {
            if let code = row.messageString {
                self.found(code: code)
                break
            }
        }
    }
}

// MARK: - AV CAPTURE DELEGATE

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first else { return }
        
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if #available(iOS 10.0, *) {
                let notification = UINotificationFeedbackGenerator()
                notification.prepare()
                notification.notificationOccurred(.success)
            } else {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
            self.found(code: stringValue)
        }
        
        self.captureSession.stopRunning()
    }
}

// MARK: - CUSTOM FUNCTIONS

extension QRScannerViewController {
    
    private func found(code: String) {
//        print(code)
        self.updateElementDelegate?.elementUpdated(fromSourceView: self, status: true, data: code)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
        captureSession = nil
    }
    
    private func createOverlay() -> UIView {
        
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let path = CGMutablePath()
        let padding: CGFloat = 80
        let width = overlayView.frame.width - padding
        
        path.addRoundedRect(in: CGRect(x: padding / 2, y: overlayView.center.y-100, width: width, height: width), cornerWidth: 10, cornerHeight: 10)
        
        path.closeSubpath()
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.lineWidth = 5.0
        shape.strokeColor = UIColor.systemYellow.cgColor
        shape.fillColor = UIColor.systemYellow.cgColor
        
        overlayView.layer.addSublayer(shape)
        
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
    
    private func addTransparentOverlayWithCirlce() {
        overlay = createOverlay()
        self.cameraView.addSubview(overlay)
//        self.view.sendSubviewToBack(overlay)
    }
    
    private func setIsVendexView(_ status: Bool) {
        self.iconImageView.image = status ? .ic_vendex_qrcode : .ic_scan_qr_code
        self.viewLabel.text = status ? "Scan QVend Code" : "Scan QR Code"
    }
}
