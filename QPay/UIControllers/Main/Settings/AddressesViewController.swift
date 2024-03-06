//
//  AddressesViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 04/05/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class AddressesViewController: MainController {
    
    @IBOutlet weak var dataStackView: UIStackView!
    
    @IBOutlet weak var dataContainerViewDesign: ViewDesign!
    
    @IBOutlet weak var placeholderViewDesign: ViewDesign!
    
    @IBOutlet weak var defaultViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var defaultAddressView: AddressView!
    
    @IBOutlet weak var addressesTableView: UITableView!
    
    var addressModels = [AddressViewModel]()
    
    private var isViewActionsHidden: Bool = true {
        willSet {
            self.defaultAddressView.addressBoardView.isActionsHidden = newValue
            for i in 0..<self.addressModels.count {
                self.addressModels[i].isActionsHidden = newValue
            }
            self.addressesTableView.reloadData()
        }
    }
    
    private var updateClosure: UpdateClosure?
    
    struct AddressViewModel {
        var isActionsHidden: Bool
        let address: Address
    }
    
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
        
        self.getAddressListRequest()
    }
}

extension AddressesViewController {
    
    func setupView() {
        self.addressesTableView.dataSource = self
        self.addressesTableView.delegate = self
        
        self.defaultAddressView.delegate = self
        
        self.dataContainerViewDesign.setViewCorners([.topLeft, .topRight])
        self.placeholderViewDesign.setViewCorners([.topLeft, .topRight])
        
        self.defaultAddressView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                            action: #selector(self.didTapDefaultView(_:)))
        )
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddressesViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        self.isViewActionsHidden.toggle()
    }
    
    @IBAction func addNewAddressAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(UpdateAddressViewController.self)
        vc.viewType = .Add
        vc.updateViewElement = self
        self.present(vc, animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension AddressesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(AddressTableViewCell.self, for: indexPath)
        
        let object = self.addressModels[indexPath.row]
        cell.address = object.address
        cell.delegate = self
        
        cell.addressView.isActionsHidden = object.isActionsHidden
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.addressModels[indexPath.row]
        self.showAddress(object.address)
    }
}

// MARK: - UPDATE VIEW ELEMENT DELEGATE

extension AddressesViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            
            self.isViewActionsHidden = true
            self.viewWillAppear(true)
            
            guard status,
                  view is UpdateAddressViewController else {
                return
            }
            
            guard let message = data as? String else { return }
            self.updateClosure = (status, message)
        }
    }
}

// MARK: - ADRESS CELL DELEGATE

extension AddressesViewController: AddressTableViewCellDelegate {
    
    func didTapShare(_ cell: AddressTableViewCell, for address: Address) {
        self.shareAddress(address)
    }
    
    func didTapSetAsDefault(_ cell: AddressTableViewCell, for address: Address) {
        self.requestProxy.requestService()?.setDefaultAddress(address._id, completion: { (status, response) in
            guard status == true else { return }
            
            self.addressModels.removeAll(where: { $0.address == address })
            if var removedAddress = self.defaultAddressView.address {
                removedAddress.isDefaultAddress = false
                self.addressModels.append(
                    AddressViewModel(isActionsHidden: self.isViewActionsHidden, address: removedAddress)
                )
            }
            self.defaultAddressView.address = address
            self.defaultAddressView.address?.isDefaultAddress = true
            self.isUserHasDefaultAddress()
            self.addressesTableView.reloadData()
        })
    }
    
    func didTapDelete(_ cell: AddressTableViewCell, for address: Address) {
        self.confirmAndDeleteAddress(address)
    }
    
    func didTapEdit(_ cell: AddressTableViewCell, for address: Address) {
        self.showEditAddress(address)
    }
}

// MARK: - ADDRESS VIEW DELEGATE

extension AddressesViewController: AddressViewDelegate {
    
    var boardDelegate: AddressBoardViewDelegate {
        get {
            return self
        }
    }
    
    var parametersDelegate: AddressParametersViewDelegate {
        get {
            return self
        }
    }
}

// MARK: - PARAMETERS VIEW DELEGATE

extension AddressesViewController: AddressParametersViewDelegate {
    
    func didTapShare(_ view: AddressParametersView, for address: Address) {
        self.shareAddress(address)
    }
    
    var parametersDesign: AddressParametersViewDesign {
        get{
            return DefaultAddressParametersDesign()
        }
    }
}

// MARK: - BOARD VIEW DELEGATE

extension AddressesViewController: AddressBoardViewDelegate {
    
    func didTapDelete(_ view: AddressBoardView, for address: Address) {
        self.confirmAndDeleteAddress(address)
    }
    
    func didTapEdit(_ view: AddressBoardView, for address: Address) {
        self.showEditAddress(address)
    }
    
    var boardDesign: AddressBoardViewDesign {
        get {
            return DefaultAddressBoardDesign()
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension AddressesViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getAddressList ||
            request == .setDefaultAddress ||
            request == .removeAddress {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                guard request == .getAddressList,
                      let closure = self.updateClosure else {
                    return
                }
                guard closure.isSuccess else { return }
                self.showSuccessMessage(closure.message)
                self.updateClosure = nil
                
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
                        self.showErrorMessage(err.localizedDescription)
                    }
                    break
                case .Runtime(_):
                    break
                }
            }
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension AddressesViewController {
    
    @objc private func didTapDefaultView(_ gesture: UIGestureRecognizer) {
        guard let address = self.defaultAddressView.address else { return }
        self.showAddress(address)
    }
    
    private func confirmAndDeleteAddress(_ address: Address) {
        self.showConfirmation(message: "Do you want to delete this address ?") {
            self.requestProxy.requestService()?.removeAddress(address._id, completion: { (status, response) in
                guard status == true else { return }
                self.showSuccessMessage(response?.message ?? "")
                if address._isDefaultAddress {
                    self.defaultAddressView.removeViewData()
                } else {
                    self.addressModels.removeAll(where: { $0.address == address })
                }
                self.addressesTableView.reloadData()
                self.isUserHasDefaultAddress()
                self.isUserHasAddresses()
            })
        }
    }
    
    private func showEditAddress(_ address: Address) {
        let vc = self.getStoryboardView(UpdateAddressViewController.self)
        vc.address = address
        vc.updateViewElement = self
        vc.viewType = .Update
        self.present(vc, animated: true)
    }
    
    private func shareAddress(_ address: Address) {
        guard let user = self.userProfile.getUser() else { return }
        
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
    
    private func showAddress(_ address: Address) {
        let vc = self.getStoryboardView(UpdateAddressViewController.self)
        vc.viewType = .Show
        vc.address = address
        vc.updateViewElement = self
        self.present(vc, animated: true)
    }
    
    private func getAddressListRequest() {
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getAddressList(completion: { (status, addressList) in
            guard status else { return }
            
            let list = addressList ?? []
            
            self.defaultAddressView.removeViewData()
            self.addressModels.removeAll()
            list.forEach({ (address) in
                if address._isDefaultAddress {
                    self.defaultAddressView.address = address
                } else {
                    self.addressModels.append(
                        AddressViewModel(isActionsHidden: self.isViewActionsHidden, address: address)
                    )
                }
            })
            self.dispatchGroup.leave()
        })
        
        self.dispatchGroup.notify(queue: .main) {
            self.addressesTableView.reloadData()
            self.isUserHasDefaultAddress()
            self.isUserHasAddresses()
        }
    }
    
    private func isUserHasDefaultAddress() {
        UIView.animate(withDuration: 0.3) {
            self.defaultViewHeight.constant = self.defaultAddressView.address == nil ? 0 : 140
        }
    }
    
    private func isUserHasAddresses() {
        let status = !self.addressModels.isEmpty || self.defaultAddressView.address != nil
        UIView.animate(withDuration: 0.3) {
            self.placeholderViewDesign.isHidden = status
            self.dataStackView.isHidden = !status
        }
    }
}

// MARK: - PARAMETERS DESIGN CLASS

class DefaultAddressParametersDesign: AddressParametersViewDesign {
    
    var shareButtonImage: UIImage {
        get {
            R.image.ic_share_my_book_product() ?? UIImage()
        }
    }
    
    var defaultButtonHidden: Bool {
        get {
            return true
        }
    }
    
    var addressNameTextColor: UIColor {
        get {
            return .mYellow
        }
    }
    
    var labelsTextColor: UIColor {
        get {
            return .white
        }
    }
}

// MARK: - BOARD DESIGN CLASS

class DefaultAddressBoardDesign: AddressBoardViewDesign {
    
    var deleteIconColor: UIColor {
        get {
            return .mYellow
        }
    }
    
    var editIconColor: UIColor {
        get {
            return .mYellow
        }
    }
    
    var isActionsHidden: Bool {
        get {
            return true
        }
    }
    
    var borderColor: UIColor {
        get {
            return .white
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return 5
        }
    }
    
    var fieldsFontSize: CGFloat {
        get {
            return 14
        }
    }
    
    var arLabelsFontSize: CGFloat {
        get {
            return 10
        }
    }
    
    var enLabelsFontSize: CGFloat {
        get {
            return 7
        }
    }
    
    var isFieldsEnabled: Bool {
        get {
            return false
        }
    }
}
