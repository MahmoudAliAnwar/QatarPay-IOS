//
//  JobHuntHomeViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class JobHuntHomeViewController: ViewController {
    
    @IBOutlet weak var jobseekerButton       : UIButton!
    
    @IBOutlet weak var vacnciesButton        : UIButton!
    
    @IBOutlet weak var skillsTextFieldDesign : TextFieldDesign!
    
    @IBOutlet weak var employmentTypeLabel   : UILabel!
    
    @IBOutlet weak var jobTitleLabel         : UILabel!
    
    @IBOutlet weak var experienceLabel       : UILabel!
    
    @IBOutlet weak var genderLabel           : UILabel!
    
    @IBOutlet weak var emailTextFieldDesign  : TextFieldDesign!
    
    @IBOutlet weak var imageSeeker           : UIImageView!
    
    @IBOutlet weak var imageVacnies          : UIImageView!
    
    @IBOutlet weak var myListButton          : ButtonDesign!
    
    var JobsList   = [JobHunterList]()
    var employeres = [EmployerList]()
    
    private var selectedEmploymentType: String?
    private var selectedJobTitle: String?
    private var selectedExperience: String?
    private var selectedGender: String?
    
    private var type  : HuntType = .jobseeker
    private var param : JobHuntSearchBodyParameter?
    
    enum HuntType : CaseIterable {
        case jobseeker
        case vacncy
    }
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension JobHuntHomeViewController {
    
    func setupView() {
        self.changeToggleBtn()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - Action

extension JobHuntHomeViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func jobseekerAction(_ sender: UIButton) {
        self.type = .jobseeker
        self.changeToggleBtn()
        self.myListButton.backgroundColor = .blue
    }
    
    @IBAction func vacnciesAction(_ sender: UIButton) {
        self.type = .vacncy
        self.changeToggleBtn()
        self.myListButton.backgroundColor = .mBook_Green
    }
    
    @IBAction func employmentTypeAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.employmentTypeLabel.text = selectedString
            self.selectedEmploymentType = selectedString
        }
        vc.list = Constant.emptypeType
        self.present(vc, animated: true)
    }
    
    @IBAction func jobTitleAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.jobTitleLabel.text = selectedString
            self.selectedJobTitle = selectedString
        }
        vc.list = Constant.jobTitles
        self.present(vc, animated: true)
    }
    
    @IBAction func experienceAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.experienceLabel.text = selectedString
            self.selectedExperience = selectedString
        }
        vc.list = Constant.experience
        self.present(vc, animated: true)
    }
    
    @IBAction func genderAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SelectDataViewController.self)
        vc.onSelect = { [weak self] (selectedString) in
            guard let self = self else { return }
            self.genderLabel.text = selectedString
            self.selectedGender = selectedString
        }
        vc.list = Constant.gender
        self.present(vc, animated: true)
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        self.param = JobHuntSearchBodyParameter(employmentType    : self.selectedEmploymentType ?? "",
                                                yearOfExperience  : self.selectedExperience ?? "",
                                                jobtitle          : self.selectedJobTitle ?? "",
                                                skills            : self.skillsTextFieldDesign.text ?? "",
                                                gender            : self.selectedGender ?? "",
                                                email             : self.emailTextFieldDesign.text ?? ""
        )
        
        guard let params = self.param else { return }
        
        switch self.type {
        case .jobseeker:
            self.requestProxy.requestService()?.getJobHuntList(jobParameter: params, { respons in
                guard let resp = respons else {
                    return
                }
                guard resp._list.isNotEmpty else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.JobsList = resp._list
                let vc     = self.getStoryboardView(ResultsSearchJobHuntViewController.self)
                vc.jobList = self.JobsList
                vc.type    = .jobSeekerSearch
                self.navigationController?.pushViewController(vc, animated: true)
            })
            break
            
        case .vacncy:
            self.requestProxy.requestService()?.getEmployerList(jobParameter: params, { respons in
                guard let resp = respons else {
                    return
                }
                guard resp._list.isNotEmpty else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.employeres = resp._list
                let vc          = self.getStoryboardView(ResultsSearchJobHuntViewController.self)
                vc.employerList = self.employeres
                vc.type         = .vacaniceSearch
                self.navigationController?.pushViewController(vc, animated: true)
            })
            break
        }
    }
    
    @IBAction func myListAction(_ sender: UIButton) {
        switch type {
        case .jobseeker:
            let vc  = self.getStoryboardView(ResultsSearchJobHuntViewController.self)
            vc.type = .myJobSeekerList
             self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .vacncy:
            let vc  = self.getStoryboardView(ResultsSearchJobHuntViewController.self)
            vc.type = .myVacaniceList
             self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
}

// MARK: - Requests Delegate

extension JobHuntHomeViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getJobHunterList {
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
                if request == .getJobHunterList {
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
}

// MARK: - Custom Function

extension JobHuntHomeViewController {
    
    private func changeToggleBtn() {
        self.imageVacnies.isHidden = self.type == .jobseeker
        self.imageSeeker.isHidden  = self.type == .vacncy
    }
}
