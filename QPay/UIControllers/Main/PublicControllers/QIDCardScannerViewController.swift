//
//  QIDCardScannerViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import CoreImage
import CropViewController

protocol QIDCardScannerViewControllerDelegate: AnyObject {
    func didDetectQIDText(_ cardData: [QIDCardScannerViewController.CardData : String], image: UIImage?)
}

public class QIDCardScannerViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet weak var blurView: BlurView!
    
    @IBOutlet weak var cameraView: QIDCameraView!
    
    @IBOutlet weak var regionOfInterestLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var semaphore = DispatchSemaphore(value: 1)
    
    private var isCalledDelegate: Bool = false
    
    private var isGreenViewShowed: Bool = false
    
    private var regionOfInterest: CGRect?
    
    private var regionOfInterestLabelFrame: CGRect?
    
    private var previewViewFrame: CGRect?
    
    private var calledDelegate = false
    
    private var backgroundBlurEffectView: UIVisualEffectView?
    
    private let successBorderColor = UIColor(displayP3Red: (111/255), green: (194/255), blue: (102/255), alpha: 1)
    
    private var capturedImage: UIImage?
    
    private var maskLayer = CAShapeLayer()
    
    private var cardData: [CardData : String] = [:] {
        didSet {
            DispatchQueue.main.async {
                guard !self.isGreenViewShowed else { return }
                self.regionOfInterestLabel.layer.borderColor = self.successBorderColor.cgColor
                self.isGreenViewShowed.toggle()
            }
        }
    }
    
    // MARK: - Public Properties
    
    weak var delegate: QIDCardScannerViewControllerDelegate?
    
    enum CardData: String, CaseIterable {
        case Number = "ID.No"
        case Expiry
        case DOB = "D.O.B"
        case Nationality
    }
    
    // MARK: - Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.calledDelegate = false
        self.setupOnViewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addBackgroundObservers()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.cameraView.stopSession()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let roiFrame = self.regionOfInterestLabel?.frame, let previewViewFrame = self.cameraView?.frame else { return }
        // store .frame to avoid accessing UI APIs in the machineLearningQueue
        self.regionOfInterestLabelFrame = roiFrame
        self.previewViewFrame = previewViewFrame
        self.setupMask()
        
        self.cameraView.setupRegionOfInterest()
    }
    
    // MARK: - Custom Functions
    
    private func setupOnViewDidLoad() {
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.regionOfInterestLabel.layer.masksToBounds = true
        self.regionOfInterestLabel.layer.cornerRadius = 10
        self.regionOfInterestLabel.layer.borderColor = UIColor.white.cgColor
        self.regionOfInterestLabel.layer.borderWidth = 4.0
        
        self.cameraView.setupCamera()
        self.cameraView.setDelegate(delegate: self)
    }
    
    func addBackgroundObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.viewOnWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.viewOnDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    private func setupMask() {
        guard let roi = self.regionOfInterestLabel else { return }
        guard let blurView = self.blurView else { return }
        blurView.maskToRoi(roi: roi)
    }
    
    @objc func viewOnWillResignActive() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.backgroundBlurEffectView = UIVisualEffectView(effect: blurEffect)
        
        guard let backgroundBlurEffectView = self.backgroundBlurEffectView else {
            return
        }
        
        backgroundBlurEffectView.frame = self.view.bounds
        backgroundBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(backgroundBlurEffectView)
    }
    
    @objc func viewOnDidBecomeActive() {
        if let backgroundBlurEffectView = self.backgroundBlurEffectView {
            backgroundBlurEffectView.removeFromSuperview()
        }
    }
    
    private func analyze(image: CGImage) {
        
        let requestHandler = VNImageRequestHandler(
            cgImage: image,
            orientation: .up,
            options: [:]
        )
        
        let textRecognitionRequest = VNRecognizeTextRequest()
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.recognitionLanguages = ["en-US"]
        textRecognitionRequest.usesLanguageCorrection = false
        
        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("\(#file) => \(#function) ERROR \(error.localizedDescription)")
            delegate = nil
        }
        
        guard let observations = textRecognitionRequest.results as? [VNRecognizedTextObservation],
              observations.count > 0 else {
                  /// No text detect
                  return
              }
        
        var tempCardData: CardData?
        
        observationsLoop: for observation in observations {
            guard let originalString = observation.topCandidates(1).first?.string,
                  observation.confidence > 0.1 else { return }
            
            if let data = tempCardData {
                switch data {
                case .DOB:
                    self.cardData[.DOB] = originalString
                    break
                    
                case .Expiry:
                    self.cardData[.Expiry] = originalString
                    break
                    
                case .Nationality:
                    self.cardData[.Nationality] = originalString
                    break
                    
                case .Number:
                    self.cardData[.Number] = originalString
                    break
                }
                
                tempCardData = nil
                if self.cardData.count == 4 {
                    break observationsLoop
                }
            }
            
            cardDataLoop: for data in CardData.allCases {
                var string = originalString
                /// To remove space from (ID. No.) label...
                if data == .Number {
                    string = originalString.replacingOccurrences(of: " ", with: "")
                }
                if string.lowercased().contains(data.rawValue.lowercased()) {
                    tempCardData = data
                    break cardDataLoop
                }
            }
        }
        
        guard self.cardData.count > 0 else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            guard self.isCalledDelegate.toggleAndReturn() else { return }
            
//            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
            let cropViewController = CropViewController(image: UIImage(cgImage: image))
            cropViewController.delegate = self
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - ACTIONS
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func closeView(_ closure: voidCompletion? = nil) {
        self.dismiss(animated: true) {
            closure?()
            self.delegate = nil
            self.isCalledDelegate = true
        }
    }
}

// MARK: - CROP CONTROLLER DELEGATE

extension QIDCardScannerViewController: CropViewControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.closeView {
                self.delegate?.didDetectQIDText(self.cardData, image: image)
            }
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: true) {
            self.closeView {
                self.delegate?.didDetectQIDText(self.cardData, image: image)
            }
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didFinishCancelled: Bool) {
        cropViewController.dismiss(animated: true) {
            self.closeView()
        }
    }
}

// MARK: - CAMERA DELEGATE

extension QIDCardScannerViewController: QIDCameraViewDelegate {
    
    internal func didCapture(image: CGImage) {
        self.analyze(image: image)
    }
    
    internal func didFailure(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cameraView.stopSession()
        }
    }
}
