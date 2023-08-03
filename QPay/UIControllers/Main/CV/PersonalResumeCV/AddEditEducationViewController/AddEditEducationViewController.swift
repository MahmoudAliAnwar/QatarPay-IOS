//
//  AddEditEducationViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 23/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol AddEditEducationViewControllerDelegate: AnyObject {
    func didTap(_ cotroller: AddEditEducationViewController, on action: AddEditEducationViewController.ActionType)
}

class AddEditEducationViewController: ViewController  {
    
    @IBOutlet weak var universityNameTextField : UITextField!
    
    @IBOutlet weak var degreeTextField         : UITextField!
    
    @IBOutlet weak var startDateTextField      : UITextField!
    
    @IBOutlet weak var endDateTextField        : UITextField!
    
    @IBOutlet weak var countryTextField        : UITextField!
    
    @IBOutlet weak var cityTextField           : UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var education : Education?
    
    weak var delegate: AddEditEducationViewControllerDelegate?
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker   = UIDatePicker()
    private let dateFormat = "MM-yyyy"
    private var dateType: DateType = .startDate
    
    enum DateType : CaseIterable {
        case startDate
        case endDate
    }
    
    enum ActionType {
        case delete(id: Int)
        case edit(Education)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension AddEditEducationViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate  = self
        self.startDateTextField.delegate              = self
        self.endDateTextField.delegate                = self
        
        self.deleteButton.isHidden = self.education == nil
    }
    
    func localized() {
    }
    
    func setupData() {
        
        guard let data = self.education else { return }
        self.universityNameTextField.text  = data._educationUniversity
        self.degreeTextField.text          = data._degree
        
        if let startDate = data._startdate.convertFormatStringToDate(ServerDateFormat.Server1.rawValue) {
            self.startDateTextField.text = "\(startDate.formatDate("MMM yyyy"))"
        }
        
        self.endDateTextField.text      = data._enddate
        self.countryTextField.text      = data._country
        self.cityTextField.text         = data._city
    }
    
    func fetchData() {
    }
}

// MARK: - Action

extension AddEditEducationViewController {
    
    @IBAction func backAction(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction(_ sender : UIButton){
        guard let educationUniversity = self.universityNameTextField.text, educationUniversity.isNotEmpty,
              let degree = self.degreeTextField.text, degree.isNotEmpty,
              let startDate = self.startDateTextField.text, startDate.isNotEmpty,
              let endDate = self.endDateTextField.text, endDate.isNotEmpty,
              let country = self.countryTextField.text, country.isNotEmpty,
              let city = self.cityTextField.text, city.isNotEmpty else {
            return
        }
        if var myEducation = education {
            myEducation.educationUniversity = educationUniversity
            myEducation.educationDegree = degree
            myEducation.educationStartDate = startDate
            myEducation.educationEndDate = endDate
            myEducation.educationCountry = country
            myEducation.educationCity = city
            
            guard let index = self.userProfile.cv?._educationList.firstIndex(where: { $0._id == myEducation.id }) else {
                return
            }
            
            self.userProfile.cv?.educationList?[index] = myEducation
            guard let cv = self.userProfile.cv else { return }
            
            self.requestProxy.requestService()?.addUpdateCV(cv: cv, { response in
                guard let resp = response else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.showSuccessMessage(resp._message)
                }
            })
            
        } else {
            var myEducation = Education()
            myEducation.educationUniversity = educationUniversity
            myEducation.educationDegree = degree
            myEducation.educationStartDate = startDate
            myEducation.educationEndDate = endDate
            myEducation.educationCountry = country
            myEducation.educationCity = city
        
            self.userProfile.cv?.educationList?.append(myEducation)
            guard let cv = self.userProfile.cv else { return }
            
            self.requestProxy.requestService()?.addUpdateCV(cv: cv, { baseResponse in
                
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong, please try again later")
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.showSuccessMessage(resp._message)
                }
            })
        }
    }
    
    @IBAction func deleteAction(_ sender : UIButton){
        
        guard let id = self.education?._id else { return }
        self.requestProxy.requestService()?.deleteCVEducation(id: id, { (respons) in
            guard let resp = respons else { return
                self.showSnackMessage("ERROR" , messageStatus: .Error)
            }
            self.showSnackMessage(resp._message, messageStatus: .Success)
            
            self.navigationController?.popViewController(animated: true)
        })
    }
}

// MARK: - FUNC CREATE DATE PICKER

extension AddEditEducationViewController {
    
    func createDatePicker(textField: UITextField)  {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn   = UIBarButtonItem(barButtonSystemItem: .done,
                                        target: self,
                                        action: #selector(self.dateDoneOnClick)
        )
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel,
                                        target: self,
                                        action: #selector(self.dateCancelOnClick)
        )
        
        toolbar.setItems([cancelBtn,doneBtn], animated: true)
        
        self.startDatePicker.datePickerMode = .date
        self.endDatePicker.datePickerMode   = .date
        
        textField.inputAccessoryView = toolbar
        
        if textField == self.startDateTextField {
            textField.inputView = self.startDatePicker
            self.dateType = .startDate
            
        } else if textField == self.endDateTextField {
            textField.inputView = self.endDatePicker
            self.dateType = .endDate
        }
    }
    
    @objc private func dateDoneOnClick() {
        
        switch self.dateType {
        case .startDate:
            let formattedDate = self.startDatePicker.date.formatDate(self.dateFormat)
            self.startDateTextField.text = formattedDate
            
        case .endDate:
            let formattedDate = self.endDatePicker.date.formatDate(self.dateFormat)
            self.endDateTextField.text = formattedDate
        }
    }
    
    @objc private func dateCancelOnClick() {
        self.view.endEditing(true)
    }
}

// MARK: - Requests Delegate

extension AddEditEducationViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .deleteEducation {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        self.hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            
            switch result {
            case .Success(_):
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

extension AddEditEducationViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.createDatePicker(textField: textField)
    }
}

