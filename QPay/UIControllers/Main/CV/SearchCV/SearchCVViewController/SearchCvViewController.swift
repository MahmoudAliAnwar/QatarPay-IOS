//
//  SearchCvViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

// TODO: CECK REQUST SEARCH CV

class SearchCvViewController: ViewController {
    
    @IBOutlet weak var skillsTextField  : TextFieldDesign!
    
    @IBOutlet weak var nationalityLabel : UILabel!
    
    @IBOutlet weak var residenceLabel   : UILabel!
    
    @IBOutlet weak var genderLabel      : UILabel!
    
    @IBOutlet weak var emailTextField   : TextFieldDesign!
    
    private var params : SearchCVParameter?
    private var searchCVResults = [CV]()
    private var selectedNationality: String?
    private var selectedResidence: String?
    private var selectedGender: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension SearchCvViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - Action

extension SearchCvViewController {
    
    @IBAction func backAction(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchCVAction(_ sender : UIButton){
        
        self.params = SearchCVParameter(nationality      : self.selectedNationality ?? "" ,
                                        yearofexperience : "" ,
                                        resident         : self.selectedResidence ?? "",
                                        skills           : self.skillsTextField.text ?? "",
                                        gender           : self.selectedGender ?? "",
                                        email            : self.emailTextField.text ?? "" )
       
        guard let params = self.params else { return }
        self.requestProxy.requestService()?.getCVListSearch(searchParams: params, { (response) in
            guard let resp = response  else { return }
            
            if resp._list.isEmpty {
                self.showErrorMessage(resp._message)
            } else {
                self.searchCVResults = resp._list
                let vc = self.getStoryboardView(ResultsCVSearchViewController.self)
                vc.resultsSearchCV = self.searchCVResults
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @IBAction func selectNationalityAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.nationalityLabel.text = selectedString
            self.selectedNationality = selectedString
        }
        vc.list = Constant.nationality
        self.present(vc, animated: true)
    }
    
    @IBAction func selectResidenceAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.residenceLabel.text = selectedString
            self.selectedResidence   = selectedString
        }
        vc.list = Constant.residency
        self.present(vc, animated: true)
    }
    
    @IBAction func selectGenderAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.genderLabel.text = selectedString
            self.selectedGender   = selectedString
        }
        vc.list = Constant.genders
        self.present(vc, animated: true)
    }
}

// MARK: - Requests Delegate

extension SearchCvViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getCVListSearch {
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

// MARK: - CUSTOM FUNCTIONS

extension SearchCvViewController {
    
}
