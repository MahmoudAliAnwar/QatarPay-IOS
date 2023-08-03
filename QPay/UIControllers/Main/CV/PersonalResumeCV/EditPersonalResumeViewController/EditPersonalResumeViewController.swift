//
//  EditPersonalResumeViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit
import Alamofire

class EditPersonalResumeViewController: ViewController {
    
    @IBOutlet weak var nameTextField         : UITextField!
    
    @IBOutlet weak var imageView             : ImageViewDesign!
    
    @IBOutlet weak var publicCheckBox        : CheckBox!
    
    @IBOutlet weak var privateCheckBox       : CheckBox!
    
    @IBOutlet weak var currentJobHeaderView  : AddPositionHeaderView!
    
    @IBOutlet weak var currentWorkTableView  : UITableView!
    
    @IBOutlet weak var previousJobHeaderView : AddPositionHeaderView!
    
    @IBOutlet weak var previousWorkTableView : UITableView!
    
    @IBOutlet weak var educationHeaderView   : AddPositionHeaderView!
    
    @IBOutlet weak var educationTableView    : UITableView!
    
    var status : Status  = ._public
    var type   : Types   = .currentJob
    var updateViewElementDelegate: UpdateViewElement?
    
    private var currentJob = [CurrentJob]()
    private let imagePicker = UIImagePickerController()
    private var imageID: Int?
    
    private lazy var customUploadView: CustomUploadView = {
        let custom = CustomUploadView(self.view)
        return custom
    }()
    
    enum Status : String {
        case _public  = "public"
        case _private = "private"
    }
    
    enum Types : CaseIterable  {
        case currentJob
        case previousJob
        case education
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
        
        guard let cv = self.userProfile.cv else { return }
        self.nameTextField.text         = cv._name
        self.publicCheckBox.isChecked   = cv._privacyStatus == Status._public.rawValue
        self.privateCheckBox.isChecked  = cv._privacyStatus == Status._private.rawValue

        cv._profilePicture.getImageFromURLString { status, image in
            guard status else { return }
            self.imageView.image = image
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension EditPersonalResumeViewController {
    
    func setupView() {
        self.imagePicker.delegate = self
        
        [
            self.currentWorkTableView,
            self.previousWorkTableView,
            self.educationTableView
        ].forEach{ table in
            
            table.delegate   = self
            table.dataSource = self
            table.registerNib(PositionDataTableCell.self)
        }
        
        [
            self.publicCheckBox,
            self.privateCheckBox
        ].forEach{check in
            check.style       = .circle
            check.borderStyle = .rounded
            check.tintColor   = .black
            check.borderWidth = 1.5
        }
        
        self.currentJobHeaderView.config  = CurrentJobHeaderConfig()
        self.previousJobHeaderView.config = PreviousJobHeaderConfig()
        self.educationHeaderView.config   = EducationJobHeaderConfig()
        
        [
            self.currentJobHeaderView,
            self.previousJobHeaderView,
            self.educationHeaderView
            
        ].forEach{header in
            header.delegate = self
        }
        
        self.publicCheckBox.addTarget(self, action: #selector(didChangePublicStatusCheckBox(_:)), for: .valueChanged)
        self.privateCheckBox.addTarget(self, action: #selector(didChangePrivateStatusCheckBox(_:)), for: .valueChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTION

extension EditPersonalResumeViewController {
    
    @IBAction func backAction(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    // FIXME: EDIT
    @IBAction func doneAction(_ sender : UIButton){
        guard var cv = self.userProfile.cv else {
            return
        }
        
        guard !self.publicCheckBox.isChecked || !self.privateCheckBox.isChecked else {
            self.showErrorMessage("Please, select public or private")
            return
        }
        
        cv.name = self.nameTextField.text
        
        self.status = self.publicCheckBox.isChecked ? ._public : ._private
        cv.privacyStatus = status.rawValue
        
//        self.requestProxy.requestService()?.addUpdateCV(cv: cv, profilePicId: imageID, { response in
//            guard let resp = response else { return }
//            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//                self.showSuccessMessage(resp._message)
//                self.userProfile.cv = cv
//            }
//        })
    }
    
    @IBAction func changeImage(_ sender : UIButton) {
        // TODO: CHANGE IMAGE
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (action) in
            guard let self = self else { return }
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] (action) in
            guard let self = self else { return }
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension EditPersonalResumeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case currentWorkTableView:
            return self.userProfile.cv?._currentJobList.count ?? 0
            
        case previousWorkTableView:
            return self.userProfile.cv?._previousJobList.count ?? 0
            
        case educationTableView:
            return self.userProfile.cv?._educationList.count ?? 0
            
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PositionDataTableCell.self, for: indexPath)
        guard let cv = self.userProfile.cv else { return cell }
        
        switch tableView {
        case currentWorkTableView :
            let object    = cv._currentJobList[indexPath.row]
            cell.object   = PositionDataTableCellAdapter.convert(object)
            cell.delegate = self
            cell.type     = .currentJob
            
        case previousWorkTableView :
            let object    = cv._previousJobList[indexPath.row]
            cell.object   = PositionDataTableCellAdapter.convert(object)
            cell.delegate = self
            cell.type     = .previousJob
            
        case educationTableView :
            let object    = cv._educationList[indexPath.row]
            cell.object   = PositionDataTableCellAdapter.convert(object)
            cell.delegate = self
            cell.type     = .education
            
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height
    }
}

// MARK: - TABLE VIEW CELL DELEGATE

extension EditPersonalResumeViewController :PositionDataTableCellDelegate {
    
    func onTapDefault(_ cell: PositionDataTableCell) {
        print("!!!")
    }
    
    func onTapEdit(_ cell: PositionDataTableCell) {
        
        guard let index = cell.indexPath,
        let cv = self.userProfile.cv else {
            return
        }
        
        switch cell.type {
        case .currentJob:
            let vc = self.getStoryboardView(AddEditJobViewController.self)
            vc.currentJob = cv._currentJobList[index.row]
            vc.jobType = .currentJob
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .previousJob:
            let vc = self.getStoryboardView(AddEditJobViewController.self)
            vc.previousJob = cv._previousJobList[index.row]
            vc.jobType = .previousJob
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .education:
            // TODO:  ONDELETE ,EDIT
            let vc = self.getStoryboardView(AddEditEducationViewController.self)
            vc.education = cv._educationList[index.row]
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
}

// MARK: - ADD POSITION HEADER DELEGATE

extension EditPersonalResumeViewController: AddPositionHeaderViewDelegate {
    
    func didTapAddPosition(_ view: AddPositionHeaderView) {
        // TODO: ADD REGUST ADD AND EDIT
        switch view {
        case self.currentJobHeaderView:
            let vc = self.getStoryboardView(AddEditJobViewController.self)
            vc.jobType = .currentJob
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case self.previousJobHeaderView:
            let vc = self.getStoryboardView(AddEditJobViewController.self)
            vc.jobType = .previousJob
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case self.educationHeaderView:
            let vc = self.getStoryboardView(AddEditEducationViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
}

// MARK: - ADD EDIT EDUCATION DELEGATE

extension EditPersonalResumeViewController: AddEditEducationViewControllerDelegate {
    
    func didTap(_ cotroller: AddEditEducationViewController, on action: AddEditEducationViewController.ActionType) {
        
    }
}

// MARK: - Add Edit Job Delegate

extension EditPersonalResumeViewController: AddEditJobViewControllerDelegate {
    
    func didTap(_ controller: AddEditJobViewController, on action: AddEditJobViewController.ActionType) {
        
        switch action {
        case .deleteCurrentJob:
            self.currentWorkTableView.reloadData()
            break
            
        case .deletePreviousJob:
            self.previousWorkTableView.reloadData()
            break
            
        case .editCurrentJob(_), .addCurrentJob(_):
            self.currentWorkTableView.reloadData()
            break
            
        case .editPreviousJob(_), .addPreviousJob(_):
            self.previousWorkTableView.reloadData()
            break
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditPersonalResumeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let user = self.userProfile.getUser() else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: imagesCompressionQuality) else { return }

        // MARK: - Send Profile Image
        
        var headers: HTTPHeaders = [:]
        let requestController = RequestsController.shared
        headers = requestController.getAuthorizationAcceptHeaders(user._access_token)
        
        DispatchQueue.global(qos: .background).async {
            
            AF.upload(multipartFormData: { multiPart in
                
                multiPart.append(imageData,
                                 withName: "image",
                                 fileName: "file.jpg",
                                 mimeType: "image/jpg")
                DispatchQueue.main.async {
                    self.customUploadView.show()
                }
                
            }, to: UPLOAD_CV_PROFILE_IMAGE, method: .post, headers: headers)
            .uploadProgress(queue: .main, closure: { progress in
                let value = Float(progress.fractionCompleted)
                self.customUploadView.progressValue = value
                
            }).responseObject { (response: DataResponse<BaseResponse, AFError>) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.customUploadView.hide()
                    switch response.result {
                    case .success(let response):
                        if response.success == true {
                            guard let id = response.imageID else {return}
                            self.imageID = id
                            self.closeView(true, data: response.message ?? "")
                            self.imageView.image = image
                          } else {
                            if showUserExceptions {
                                self.showErrorMessage(response.message)
                            }
                        }
                    case .failure(let err):
                        if showAlamofireErrors {
                            self.showSnackMessage(err.localizedDescription)
                         }
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - CURRENT JOB HEADER CONFIG

class CurrentJobHeaderConfig: AddPositionHeaderViewConfig {
    
    var icon: UIImage {
        get {
            return .ic_cv_job
        }
    }
    
    var title: String {
        get {
            return "CURRENT JOB"
        }
    }
}

// MARK: - CURRENT JOB HEADER CONFIG

class PreviousJobHeaderConfig: AddPositionHeaderViewConfig {
    
    var icon: UIImage {
        get {
            return .ic_cv_job
        }
    }
    
    var title: String {
        get {
            return "PREVIOUS JOB"
        }
    }
}

// MARK: - CURRENT JOB HEADER CONFIG

class EducationJobHeaderConfig: AddPositionHeaderViewConfig {
    
    var isTitleStackHidden: Bool {
        get { return true }
    }
}

// MARK: - REQUESTS DELEGATE

extension EditPersonalResumeViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        
        if request == .addUpdateCV {
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

// MARK: - PRIVATE FUNCTIONS

extension EditPersonalResumeViewController {
    
    private func closeView(_ status: Bool, data: Any?) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
}

// MARK: - CUSTOM FUNCTIONS...

extension EditPersonalResumeViewController {
    
    @objc
    private func didChangePublicStatusCheckBox(_ checkBox: CheckBox) {
        self.privateCheckBox.isChecked = !checkBox.isChecked
        self.status = ._public
    }
    
    @objc
    private func didChangePrivateStatusCheckBox(_ checkBox: CheckBox) {
        self.publicCheckBox.isChecked = !checkBox.isChecked
        self.status = ._private
    }
}

