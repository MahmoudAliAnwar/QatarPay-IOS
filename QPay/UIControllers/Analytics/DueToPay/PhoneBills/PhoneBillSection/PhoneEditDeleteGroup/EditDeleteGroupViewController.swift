//
//  EditDeleteGroupViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class EditDeleteGroupViewController: ViewController {
    
    @IBOutlet weak var tableView       : UITableView!
        
    var groups = [Group]()
    var operatorType: AddPhoneBillsCardViewController.OperatorTypes?
    
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
}

extension EditDeleteGroupViewController {
    
    func setupView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(EditDeleteGroupTableCell.self)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension EditDeleteGroupViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension EditDeleteGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(EditDeleteGroupTableCell.self, for: indexPath)
        
        let object = self.groups[indexPath.row]
        cell.object = object
        cell.delegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let object = self.<#Array#>[indexPath.row]
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}



// MARK: - CUSTOM FUNCTIONS

extension EditDeleteGroupViewController {
    
}


// MARK: - Edit Delete Group Table Cell Delegate

extension EditDeleteGroupViewController : EditDeleteGroupTableCellDelegate {
    
    func didTapDeleteGroup(_ cell: EditDeleteGroupTableCell, for group: Group) {
        
        guard let operatorID = self.operatorType?.rawValue else {
            self.showSnackMessage("Something went wrong")
            return
        }
        
        let alert = UIAlertController(title: "", message: "Do you want Delete this group ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            self.showLoadingView(self)
            self.requestProxy.requestService()?.removePhoneGroup(operatorID: operatorID, groupID: group._id, { baseResponse in
                self.hideLoadingView()
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong")
                    return
                }

                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.showSuccessMessage(resp._message)
                self.groups.removeAll(where: { $0._id == group._id })
                self.tableView.reloadData()

            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func didTapEditGroup(_ cell: EditDeleteGroupTableCell, for group: Group) {
        let vc    = self.getStoryboardView(EditGroupNameViewController.self)
        vc.groupBillType = .phoneBill
        vc.operatorType = self.operatorType
        vc.group = group
        vc.updateViewDelegate = EditGroupNameViewController() as?  UpdateViewElement
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

extension EditDeleteGroupViewController : EditGroupNameViewControllerDelegate {
    func endEditGroupName( for group: Group, name: String) {
        if let i  = self.groups.firstIndex(where: { $0._id == group._id }) {
            groups[i].name = name
            self.tableView.reloadData()
        }
    }
}
