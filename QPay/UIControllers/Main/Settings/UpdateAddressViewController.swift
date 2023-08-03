//
//  ResetPinViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UpdateAddressViewController: ViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var addressBoardView: AddressBoardView!
    
    @IBOutlet weak var addressNameTextField: UITextField!
    
    @IBOutlet weak var streetNameTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var actionStackView: UIStackView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    var updateViewElement: UpdateViewElement?
    var address: Address?
    
    var viewType: ViewType = .Add
    
    public enum ViewType {
        case Show
        case Update
        case Add
    }
    
    private var locationManager: CLLocationManager!
    
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
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension UpdateAddressViewController {
    
    func setupView() {
        self.configureViewUpdateOrSave()
        
        self.shareButton.isHidden = true
        
        self.addressBoardView.delegate = self
        
        self.addressNameTextField.delegate = self
        self.streetNameTextField.delegate = self
    }
    
    func localized() {
    }
    
    func setupData() {
        
        if self.viewType == .Update ||
            self.viewType == .Show {
            guard let add = self.address else { return }
            
            self.addressNameTextField.text = add._name
            self.streetNameTextField.text = add._streetName
            
            self.addressBoardView.address = add
            
            guard let latitude = add.latitude,
                  let longitude = add.longitude else {
                return
            }
            
            guard latitude != "0" && longitude != "0" else {
                self.determineCurrentLocation()
                return
            }
            
            guard let lat = Double(latitude),
                  let long = Double(longitude) else {
                return
            }
            self.setMapRegion(latitude: lat, longitude: long)
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension UpdateAddressViewController {
    
    @IBAction func shareAction(_ sender: UIButton) {
        guard self.viewType == .Show,
              let user = self.userProfile.getUser(),
              let address = self.address else {
                  return
              }
        
        let data: [Any] = [
            user._fullName,
            "Address: \(address._name), \(address._streetName), \(address._city), \(address._country)",
            "PoBox : \(address._poBox)",
            "Street : \(address._streetNumber)",
            "Zone : \(address._zone)",
            "Building Number : \(address._buildingNumber)",
            "Map : https://www.google.com/maps/@\(address._longitude),\(address._latitude)"
        ]
        
        self.openShareDialog(sender: view,
                             data: data) { isComplete in
            if isComplete {
            } else {
            }
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.closeView(false)
    }
    
    @IBAction func updateSaveAction(_ sender: UIButton) {
        
        guard let buildingNumber = self.addressBoardView.buildingNumberTextField.text, buildingNumber.isNotEmpty,
              let zone = self.addressBoardView.zoneTextField.text, zone.isNotEmpty,
              let streetNumber = self.addressBoardView.streetNumberTextField.text, streetNumber.isNotEmpty,
              let addressName = self.addressNameTextField.text, addressName.isNotEmpty,
              let streetName = self.streetNameTextField.text, streetName.isNotEmpty else {
            
            self.showErrorMessage("Please, enter your address")
            return
        }
        
        var addressModel = Address()
        
        if self.viewType == .Update {
            guard let model = self.address else { return }
            addressModel = model
        }
        
        addressModel.buildingNumber = buildingNumber
        addressModel.zone = zone
        addressModel.streetNumber = streetNumber
        addressModel.streetName = streetName
        addressModel.name = addressName
        
        self.requestProxy.requestService()?.validateAddress(address: addressModel, completion: { (status, response) in
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                guard status == true else {
                    self.showErrorMessage(response?.message)
                    return
                }
                guard let latitude = response?.latitude,
                      let longitude = response?.longitude,
                      let lat = Double(latitude),
                      let long = Double(longitude) else {
                    return
                }
                self.setMapRegion(latitude: lat, longitude: long)
                
                switch self.viewType {
                case .Update:
                    self.requestProxy.requestService()?.updateUserAddress(addressModel, completion: { (status, response) in
                        guard status == true else { return }
                    })
                    break
                case .Add:
                    self.requestProxy.requestService()?.saveAddress(address: addressModel, completion: { (status, response) in
                        guard status == true else { return }
                    })
                    break
                case .Show:
                    break
                }
            }
        })
    }
}

// MARK: - ADDRESS BOARD DELEGATE

extension UpdateAddressViewController: AddressBoardViewDelegate {
    
    var boardDesign: AddressBoardViewDesign {
        get {
            return UpdateAddressBoardDesign()
        }
    }
}

// MARK: - REQUEST DELEGATE

extension UpdateAddressViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .validateAddress ||
            request == .updateUserAddress ||
            request == .saveAddress {
            self.showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                guard request == .saveAddress ||
                        request == .updateUserAddress else {
                    return
                }
                guard let response = data as? BaseResponse,
                      response.success == true else {
                    return
                }
                
                self.closeView(true, data: response.message)
                
                break
            case .Failure(let errorType):
                switch errorType {
                case .Exception(let exc):
                    if showUserExceptions {
                        self.showErrorMessage(exc)
                    }
                    break
                case .AlamofireError(let err):
                    if showAlamofireErrors {
                        self.showSnackMessage(err.localizedDescription)
                    }
                    break
                case .Runtime(_):
                    break
                }
            }
        }
    }
}

// MARK: - TEXT FIELD DELEGATE

extension UpdateAddressViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.addressNameTextField {
            self.streetNameTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
}

// MARK: - MAP DELEGATE

extension UpdateAddressViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        
        self.setMapRegion(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}

// MARK: - PRIVATE FUNCTIONS

extension UpdateAddressViewController {
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.dismiss(animated: true)
        self.updateViewElement?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
    
    private func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setMapRegion(latitude: Double, longitude: Double) {
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06))
        
        let ann = MKPointAnnotation()
        ann.coordinate = center
        
        self.mapView.showsUserLocation = true
        self.mapView.addAnnotation(ann)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.mapView.setRegion(mRegion, animated: true)
        } completion: { (_) in
        }
    }
    
    private func configureViewUpdateOrSave() {
        switch self.viewType {
        case .Show:
            self.titleLabel.text = "Show Address"
            self.actionStackView.isHidden = true
//            self.shareButton.isHidden = false
            break
        case .Update:
//            self.shareButton.isHidden = true
            self.titleLabel.text = "Update Address"
            self.actionButton.setTitle("Update Address", for: .normal)
            break
        case .Add:
//            self.shareButton.isHidden = true
            self.titleLabel.text = "Add New Address"
            self.actionButton.setTitle("Add Address", for: .normal)
            break
        }
    }
}

// MARK: - BOARD DESIGN CLASS

class UpdateAddressBoardDesign: AddressBoardViewDesign {
    
    var borderColor: UIColor {
        get {
            return .systemGray5
        }
    }
    
    var deleteIconColor: UIColor {
        get {
            return .clear
        }
    }
    
    var editIconColor: UIColor {
        get {
            return .clear
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return 10
        }
    }
    
    var fieldsFontSize: CGFloat {
        get {
            return 24
        }
    }
    
    var arLabelsFontSize: CGFloat {
        get {
            return 18
        }
    }
    
    var enLabelsFontSize: CGFloat {
        get {
            return 10
        }
    }
    
    var isFieldsEnabled: Bool {
        get {
            return true
        }
    }
    
    var isActionsHidden: Bool {
        get {
            return true
        }
    }
}
