//  Created by josh on 2020/07/23.

import AVFoundation
import UIKit

/// Conform to this delegate to get notified of key events
@available(iOS 13, *)
public protocol CreditCardScannerViewControllerDelegate: AnyObject {
    /// Called user taps the cancel button. Comes with a default implementation for UIViewControllers.
    /// - Warning: The viewController does not auto-dismiss. You must dismiss the viewController
    func creditCardScannerViewControllerDidCancel(_ viewController: CreditCardScannerViewController)
    /// Called when an error is encountered
    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didErrorWith error: CreditCardScannerError)
    /// Called when finished successfully
    /// - Note: successful finish does not guarentee that all credit card info can be extracted
    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didFinishWith card: VisionCreditCard)
}

@available(iOS 13, *)
public extension CreditCardScannerViewControllerDelegate where Self: UIViewController {
    func creditCardScannerViewControllerDidCancel(_ viewController: CreditCardScannerViewController) {
        viewController.dismiss(animated: true)
    }
}

@available(iOS 13, *)
open class CreditCardScannerViewController: UIViewController {
    
    @IBOutlet weak var scanCardLabel: UILabel!
    @IBOutlet weak var positionCardLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var blurView: BlurView!
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var regionOfInterestLabel: UILabel!
    @IBOutlet weak var cornerView: CornerView!
    
    @objc public var scanCardFont: UIFont?
    @objc public var positionCardFont: UIFont?
    @objc public var cornerColor: UIColor?
    
//    @objc public var includeCardImage = false
    
    static var isAppearing = false
    
    private var regionOfInterestLabelFrame: CGRect?
    private var previewViewFrame: CGRect?
    
    @objc var backgroundBlurEffectView: UIVisualEffectView?
    
    public var regionOfInterestCornerRadius = CGFloat(10.0)
    
    private var calledDelegate = false
    private var calledOnScannedCard = false
    
    private var initialVideoOrientation: AVCaptureVideoOrientation {
        return .portrait
    }
    
    private var cornerBorderColor = UIColor.green.cgColor
    private var denyPermissionTitle = "Need camera access"
    private var denyPermissionMessage = "Please enable camera access in your settings to scan your card"
    var denyPermissionButtonText = "OK"
    
    // MARK: - Subviews and layers
    
    /// View representing live camera
//    private lazy var cameraView: CameraView = CameraView(delegate: self)
    
    /// Analyzes text data for credit card info
    private lazy var analyzer = ImageAnalyzer(delegate: self)
    
    private weak var delegate: CreditCardScannerViewControllerDelegate?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUiCustomization()
        self.calledDelegate = false
        
        self.setupOnViewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addBackgroundObservers()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.cameraView.stopSession()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let roiFrame = self.regionOfInterestLabel?.frame, let previewViewFrame = self.cameraView?.frame else { return }
        // store .frame to avoid accessing UI APIs in the machineLearningQueue
        self.regionOfInterestLabelFrame = roiFrame
        self.previewViewFrame = previewViewFrame
        self.setUpCorners()
        self.setupMask()
        
        self.cameraView.setupRegionOfInterest()
    }
}

// MARK: - ACTIONS

extension CreditCardScannerViewController {
    
    @IBAction func closeButtonPress(_ sender: UIButton) {
        // Note: for the back button we may call the `userCancelled` delegate even if the
        // delegate has been called just as a safety precation to always provide the
        // user with a way to get out.
        
        self.cancel(sender)
        self.calledDelegate = true
    }
}

// MARK: - CUSTOM FUNCTIONS

extension CreditCardScannerViewController {
    
    private func cancel(_ sender: UIButton) {
        self.delegate?.creditCardScannerViewControllerDidCancel(self)
    }
    
    static func createViewController(withDelegate delegate: CreditCardScannerViewControllerDelegate? = nil) -> CreditCardScannerViewController? {
        // use default config
        return self.createViewController(withDelegate: delegate, configuration: ScanConfiguration())
    }
    
    static func createViewController(withDelegate delegate: CreditCardScannerViewControllerDelegate? = nil, configuration: ScanConfiguration) -> CreditCardScannerViewController? {
        
        guard self.isCompatible(configuration: configuration) else {
            return nil
        }
        
        // The forced unwrap here is intentional -- we expect this to crash
        // if someone uses it with an invalid bundle
        
        let viewController = UIStoryboard.getStoryboardFromController(with: CreditCardScannerViewController.self)
        viewController.delegate = delegate
        
        return viewController
    }
    
    func setUiCustomization() {
        if let font = self.scanCardFont {
            self.scanCardLabel.font = font
        }
        if let font = self.positionCardFont {
            self.positionCardLabel.font = font
        }
        if let color = self.cornerColor {
            self.cornerBorderColor = color.cgColor
        }
    }
    
    private func setupMask() {
        guard let roi = self.regionOfInterestLabel else { return }
        guard let blurView = self.blurView else { return }
        blurView.maskToRoi(roi: roi)
    }
    
    private func setUpCorners() {
        guard let roi = self.regionOfInterestLabel else { return }
        guard let corners = self.cornerView else { return }
        corners.setFrameSize(roi: roi)
        corners.drawCorners()
    }
    
    private func setupOnViewDidLoad() {
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.cornerView.layer.borderColor = self.cornerBorderColor
        self.regionOfInterestLabel.layer.masksToBounds = true
        self.regionOfInterestLabel.layer.cornerRadius = self.regionOfInterestCornerRadius
        self.regionOfInterestLabel.layer.borderColor = UIColor.white.cgColor
        self.regionOfInterestLabel.layer.borderWidth = 2.0
        
        self.cameraView.setupCamera()
        self.cameraView.setDelegate(delegate: self)
    }
    
    func addBackgroundObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewOnWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewOnDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    static func isCompatible() -> Bool {
        return self.isCompatible(configuration: ScanConfiguration())
    }

    static func isCompatible(configuration: ScanConfiguration) -> Bool {
        // check to see if the user has already denined camera permission
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizationStatus != .authorized && authorizationStatus != .notDetermined && configuration.setPreviouslyDeniedDevicesAsIncompatible {
            return false
        }
        
        // make sure that we don't run on iPhone 6 / 6plus or older
        if configuration.runOnOldDevices {
            return true
        }
        switch Api.deviceType() {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3", "iPhone4,1":
            return true
        case "iPhone5,1", "iPhone5,2", "iPhone5,3", "iPhone5,4", "iPhone6,1", "iPhone6,2", "iPhone7,2", "iPhone7,1":
            return true
        default:
            return true
        }
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
}

@available(iOS 13, *)
extension CreditCardScannerViewController: CameraViewDelegate {
    
    internal func didCapture(image: CGImage) {
        analyzer.analyze(image: image)
    }

    internal func didError(with error: CreditCardScannerError) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: error)
            strongSelf.cameraView.stopSession()
        }
    }
}

@available(iOS 13, *)
extension CreditCardScannerViewController: ImageAnalyzerProtocol {
    
    internal func didFinishAnalyzation(with result: Result<VisionCreditCard, CreditCardScannerError>) {
        switch result {
        case let .success(creditCard):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView.stopSession()
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didFinishWith: creditCard)
            }

        case let .failure(error):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView.stopSession()
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: error)
            }
        }
    }
}

@available(iOS 13, *)
extension AVCaptureDevice {
    
    static func authorize(authorizedHandler: @escaping ((Bool) -> Void)) {
        let mainThreadHandler: ((Bool) -> Void) = { isAuthorized in
            DispatchQueue.main.async {
                authorizedHandler(isAuthorized)
            }
        }
        
        switch authorizationStatus(for: .video) {
        case .authorized:
            mainThreadHandler(true)
        case .notDetermined:
            requestAccess(for: .video, completionHandler: { granted in
                mainThreadHandler(granted)
            })
        default:
            mainThreadHandler(false)
        }
    }
}
