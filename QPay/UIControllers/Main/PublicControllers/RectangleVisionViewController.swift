//
//  RectangleVisionViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 02/06/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CropViewController

protocol RectangleVisionViewControllerDelegate: AnyObject {
    func didDetectImage(_ image: UIImage)
}

class RectangleVisionViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private var maskLayer = CAShapeLayer()
    
    private var isTapped = false
    var cornerBorderColor = UIColor.white.cgColor
    var calledDelegate = false
    
    @objc var backgroundBlurEffectView: UIVisualEffectView?
    
    weak var delegate: RectangleVisionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.videoDataOutput.setSampleBufferDelegate(nil, queue: nil)
        self.captureSession.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.previewLayer.frame = self.view.frame
    }
}

extension RectangleVisionViewController {
    
    func setupView() {
        self.setCameraInput()
        self.showCameraFeed()
        self.setCameraOutput()
        
        self.calledDelegate = false
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                             target: self,
                                             action: #selector(self.didTapCloseView(_:)))
        rightBarButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightBarButton
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension RectangleVisionViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - AVCAPTURE DELEGATE

extension RectangleVisionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
        self.detectRectangle(in: frame)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension RectangleVisionViewController {
    
    @objc private func didTapCloseView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func setCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
                mediaType: .video,
                position: .back).devices.first else {
            fatalError("No back camera device found.")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func showCameraFeed() {
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.frame
    }
    
    private func setCameraOutput() {
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        
        guard let connection = self.videoDataOutput.connection(with: .video),
              connection.isVideoOrientationSupported else {
            return
        }
        
        connection.videoOrientation = .portrait
    }
    
    private func detectRectangle(in image: CVPixelBuffer) {
        
        let request = VNDetectRectanglesRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                
                guard let results = request.results as? [VNRectangleObservation] else { return }
                self.removeMask()
                
                guard let rect = results.first else { return }
                self.drawBoundingBox(rect: rect)
                
                if self.isTapped && !self.calledDelegate {
                    self.isTapped = false
                    self.captureSession.stopRunning()
                    self.calledDelegate = true
                    self.doPerspectiveCorrection(rect, from: image)
                }
            }
        })
        
        request.minimumAspectRatio = VNAspectRatio(1.3)
        request.maximumAspectRatio = VNAspectRatio(1.6)
        request.minimumSize = Float(0.5)
        request.maximumObservations = 1
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
        
        self.startCapturing()
        
        try? imageRequestHandler.perform([request])
    }
    
    private func doPerspectiveCorrection(_ observation: VNRectangleObservation, from buffer: CVImageBuffer) {
        var ciImage = CIImage(cvImageBuffer: buffer)
        
        let topLeft = observation.topLeft.scaled(to: ciImage.extent.size)
        let topRight = observation.topRight.scaled(to: ciImage.extent.size)
        let bottomLeft = observation.bottomLeft.scaled(to: ciImage.extent.size)
        let bottomRight = observation.bottomRight.scaled(to: ciImage.extent.size)
        
        // pass those to the filter to extract/rectify the image
        ciImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: topLeft),
            "inputTopRight": CIVector(cgPoint: topRight),
            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
            "inputBottomRight": CIVector(cgPoint: bottomRight),
        ])
        
        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        let output = UIImage(cgImage: cgImage!)
        //UIImageWriteToSavedPhotosAlbum(output, nil, nil, nil)
        
//        self.dismiss(animated: true) {
//            self.delegate?.didDetectImage(output)
//        }
        
        self.removeMask()
        
        let cropViewController = CropViewController(image: output)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    private func startCapturing(after seconds: Int = 3) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            for _ in 1...seconds {
                sleep(1)
            }
            DispatchQueue.main.async {
                self.isTapped = true
            }
        }
    }
    
    private func drawBoundingBox(rect : VNRectangleObservation) {
        
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.previewLayer.frame.height)
        let scale = CGAffineTransform.identity.scaledBy(x: self.previewLayer.frame.width, y: self.previewLayer.frame.height)
        
        let bounds = rect.boundingBox.applying(scale).applying(transform)
        self.createLayer(in: bounds)
    }
    
    private func createLayer(in rect: CGRect) {
        
        self.maskLayer = CAShapeLayer()
        self.maskLayer.frame = rect
        self.maskLayer.cornerRadius = 10
        self.maskLayer.opacity = 0.75
        self.maskLayer.borderColor = UIColor.green.cgColor
        self.maskLayer.borderWidth = 5.0
        
        self.previewLayer.insertSublayer(maskLayer, at: 1)
    }
    
    private func removeMask() {
        self.maskLayer.removeFromSuperlayer()
    }
    
    private func closeView(_ closure: voidCompletion? = nil) {
        self.dismiss(animated: true) {
            closure?()
            self.delegate = nil
        }
    }
}

// MARK: - CROP CONTROLLER DELEGATE

extension RectangleVisionViewController: CropViewControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.closeView {
                self.delegate?.didDetectImage(image)
            }
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: true) {
            self.closeView {
                self.delegate?.didDetectImage(image)
            }
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didFinishCancelled: Bool) {
        cropViewController.dismiss(animated: true) {
            self.closeView()
        }
    }
}
