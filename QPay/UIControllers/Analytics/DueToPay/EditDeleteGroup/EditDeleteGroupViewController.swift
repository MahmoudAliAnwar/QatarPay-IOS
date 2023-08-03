//
//  EditDeleteGroupViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class EditDeleteGroupViewController: UIViewController {
    
    @IBOutlet weak var tableView       : UITableView!
    @IBOutlet weak var headerImageView : UIImageView!
    
    
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

extension EditDeleteGroupViewController : EditDeleteGroupTableCellDelegate {
    
    func didTapDeleteGroup(_ cell: EditDeleteGroupTableCell, for group: Group) {
        print("")
    }
    
    func didTapEditGroup(_ cell: EditDeleteGroupTableCell, for group: Group) {
        let vc    = self.getStoryboardView(EditGroupNameViewController.self)
        vc.operatorType = self.operatorType
        vc.group = group
        vc.updateViewDelegate = EditGroupNameViewController() as?  UpdateViewElement
        self.present(vc, animated: true)
    }
    
    
}
