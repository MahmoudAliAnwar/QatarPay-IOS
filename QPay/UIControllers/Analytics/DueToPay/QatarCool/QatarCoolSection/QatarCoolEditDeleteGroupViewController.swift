//
//  QatarCoolEditDeleteGroupViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 02/08/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class QatarCoolEditDeleteGroupViewController: ViewController {

    @IBOutlet weak var tableView       : UITableView!
    
    var groups = [Group]()
    
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

extension QatarCoolEditDeleteGroupViewController {
    
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

extension QatarCoolEditDeleteGroupViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension QatarCoolEditDeleteGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Edit Delete Group Table Cell Delegate

extension QatarCoolEditDeleteGroupViewController : EditDeleteGroupTableCellDelegate {
    
    func didTapDeleteGroup(_ cell: EditDeleteGroupTableCell, for group: Group) {
        
        let alert = UIAlertController(title: "", message: "Do you want Delete this group ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive , handler: { _ in
            self.showLoadingView(self)
            self.requestProxy.requestService()?.removeQatarCoolGroup(groupID: group._id, { baseResponse in
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
        vc.groupBillType = .qatarCool
        vc.group         = group
        vc.delegate      = self
        vc.updateViewDelegate = EditGroupNameViewController() as?  UpdateViewElement
        self.present(vc, animated: true)
    }
}

// MARK: - Edit Group Name View Controller Delegate

extension QatarCoolEditDeleteGroupViewController : EditGroupNameViewControllerDelegate {
    func endEditGroupName( for group: Group, name: String) {
        if let i  = self.groups.firstIndex(where: { $0._id == group._id }) {
            groups[i].name = name
            self.tableView.reloadData()
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension QatarCoolEditDeleteGroupViewController {
    
}
