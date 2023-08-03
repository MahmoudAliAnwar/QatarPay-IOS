//
//  AddPhoneBillsCardViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class AddPhoneBillsCardViewController: PhoneBillsController {
    
    @IBOutlet weak var groupListButton: UIButton!
    @IBOutlet weak var operatorListButton: UIButton!
    
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var mobileErrorImageView: UIImageView!
    
    @IBOutlet weak var qidTextField: UITextField!
    @IBOutlet weak var qidErrorImageView: UIImageView!
    
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var ownerErrorImageView: UIImageView!
    
    var operatorType: OperatorTypes?
    
    private var groupDropDown = DropDown()
    private var operatorDropDown = DropDown()
    
    private var groups = [Group]()
    private var operators = [PhoneOperator]()
    private var groupName: String?
    private var operatorName: String?
    
    public enum OperatorTypes: Int, CaseIterable {
        case ooredoo = 1
        case vodafone
    }
    
    private let mobileMaxDigit: Int = 8
    
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
        
        self.requestProxy.requestService()?.delegate = self
        
        self.fetchGroupData()
        //        self.fetchOperatorData()
    }
}

extension AddPhoneBillsCardViewController {
    
    func setupView() {
        self.setupGroupDropDown()
        self.setupOperatorDropDown()
        
        self.mobileTextField.delegate = self
        self.qidTextField.delegate = self
        
        self.changeStatusBarBG(color: .clear)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        guard let type = self.operatorType else { return }
        switch type {
        case .ooredoo:
            self.operatorListButton.setTitle("Ooreedoo", for: .normal)
            break
            
        case .vodafone:
            self.operatorListButton.setTitle("Vodafone", for: .normal)
            break
        }
    }
}

// MARK: - ACTIONS

extension AddPhoneBillsCardViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func groupDropDownAction(_ sender: UIButton) {
        
        if self.groupDropDown.dataSource.isEmpty {
            self.showSnackMessage("You don't have groups yet\nClick Create Group to add one")
        }else {
            self.groupDropDown.show()
        }
    }
    
    @IBAction func operatorDropDownAction(_ sender: UIButton) {
        //        self.operatorDropDown.show()
    }
    
    @IBAction func createGroupAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(CreatePhoneBillsGroupViewController.self)
        vc.operatorType = self.operatorType
        vc.updateViewDelegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func addNumberAction(_ sender: UIButton) {
        
        guard let operatorType = self.operatorType else { return }
        
        guard let group = self.groupName else {
            self.showSnackMessage("Please, select group to continue")
            return
        }
        
        if self.mobileTextField.text!.isEmpty {
            self.showHideMobileError()
            
        }else if self.qidTextField.text!.isEmpty {
            self.showHideMobileError(action: .hide)
            self.showHideQIDError()
            
        }else if self.ownerTextField.text!.isEmpty {
            self.showHideMobileError(action: .hide)
            self.showHideQIDError(action: .hide)
            self.showHideOwnerError()
            
        }else {
            self.showHideMobileError(action: .hide)
            self.showHideQIDError(action: .hide)
            self.showHideOwnerError(action: .hide)
            
            guard let mobile = self.mobileTextField.text, mobile.isNotEmpty,
                  let qid = self.qidTextField.text, qid.isNotEmpty,
                  let owner = self.ownerTextField.text, owner.isNotEmpty else {
                return
            }
            
            guard mobile.count == self.mobileMaxDigit else {
                self.showSnackMessage("Mobile number should be \(self.mobileMaxDigit) digits")
                return
            }
            
            guard qid.count == self.qidMaxDigit else {
                self.showSnackMessage("QID should be \(self.qidMaxDigit) digits")
                return
            }
            
            let selectedGroup = self.groups.filter({ $0.name!.contains(group) }).first
            
            let oId = operatorType.rawValue
            guard let gId = selectedGroup?.id else { return }
            
            self.requestProxy.requestService()?.addPhoneToGroup(groupID: gId, phoneNumber: mobile, QID: qid, subscriberName: owner, operatorID: oId) { (status, response) in
                guard status == true else { return }
            }
        }
    }
    
    @IBAction func editDeleteGroupAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditDeleteGroupViewController.self)
        vc.groups = self.groups
        vc.operatorType = self.operatorType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// 056 800 2216
// MARK: - REQUESTS DELEGATE

extension AddPhoneBillsCardViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addPhoneToGroup {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                if request == .addPhoneToGroup {
                    guard let response = data as? BaseResponse else { return }
                    self.showSuccessMessage(response.message)
                }
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

// MARK: - UPDATE VIEW ELEMENT DELEGATE

extension AddPhoneBillsCardViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        if view is CreatePhoneBillsGroupViewController {
            self.viewWillAppear(true)
        }
    }
}

// MARK: - TEXT FIELD DELEGATE

extension AddPhoneBillsCardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == self.mobileTextField {
            return count <= self.mobileMaxDigit
            
        }else if textField == self.qidTextField {
            return count <= self.qidMaxDigit
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.mobileTextField {
            self.qidTextField.becomeFirstResponder()
            
        } else if textField == self.qidTextField {
            self.ownerTextField.becomeFirstResponder()
            
        } else if textField == self.ownerTextField {
            self.view.endEditing(true)
        }
        return true
    }
}

// MARK: - CUSTOM FUNCTIONS

extension AddPhoneBillsCardViewController {
    
    private func showHideMobileError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            self.mobileErrorImageView.image = .none
        case .show:
            self.mobileErrorImageView.image = #imageLiteral(resourceName: "ic_error_circle")
        }
    }
    
    private func showHideQIDError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            self.qidErrorImageView.image = .none
        case .show:
            self.qidErrorImageView.image = #imageLiteral(resourceName: "ic_error_circle")
        }
    }
    
    private func showHideOwnerError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            self.ownerErrorImageView.image = .none
        case .show:
            self.ownerErrorImageView.image = #imageLiteral(resourceName: "ic_error_circle")
        }
    }
    
    private func setupGroupDropDown() {
        
        self.configureDropDownAppearance(self.groupDropDown, dropBtn: self.groupListButton)
        
        self.groupDropDown.selectionAction = { [weak self] (index, item) in
            self?.groupListButton.setTitle(item, for: .normal)
            self?.groupName = item
        }
    }
    
    private func setupOperatorDropDown() {
        
        self.configureDropDownAppearance(self.operatorDropDown, dropBtn: self.operatorListButton)
        
        self.operatorDropDown.selectionAction = { [weak self] (index, item) in
            self?.operatorListButton.setTitle(item, for: .normal)
            self?.operatorName = item
        }
    }
    
    private func fetchGroupData() {
        
        var names = [String]()
        
        self.dispatchGroup.enter()
        
        guard let type = self.operatorType else { return }
        self.requestProxy.requestService()?.getPhoneUserGroups(operatorID: type.rawValue) { (status, phoneGroups) in
            
            if let groups = phoneGroups {
                groups.forEach { (group) in
                    self.groups = groups
                    if let name = group.name {
                        names.append(name)
                    }
                }
            }
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main, execute: {
            self.groupDropDown.dataSource = names
            self.groupDropDown.reloadAllComponents()
        })
    }
    
    private func fetchOperatorData() {
        
        var names = [String]()
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.getPhoneUserOperators { (status, phoneOperators) in
            
            if let operators = phoneOperators {
                operators.forEach { (myOperator) in
                    self.operators = operators
                    if let text = myOperator.text {
                        names.append(text)
                    }
                }
            }
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.operatorDropDown.dataSource = names
            self.operatorDropDown.reloadAllComponents()
        })
    }
    
    private func configureDropDownAppearance(_ dropDown: DropDown, dropBtn: UIButton) {
        let appearance = DropDown.appearance()
        
        dropDown.anchorView = dropBtn
        
        dropDown.bottomOffset = CGPoint(x: 0, y: dropBtn.bounds.height)
        dropDown.direction = .bottom
        dropDown.dismissMode = .onTap
        
        appearance.cellHeight = dropBtn.bounds.height
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.8
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = appBackgroundColor
    }
}
