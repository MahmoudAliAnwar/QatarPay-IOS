//
//  LibraryView.swift
//  QPay
//
//  Created by Dev. Mohmd on 02/12/2020.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class LibraryView: UIView {
    
    @IBOutlet weak var libraryContatinerViewDesign: ViewDesign!
    
    @IBOutlet weak var libraryImageView: UIImageView!
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var libraryCountLabel: UILabel!
    @IBOutlet weak var libraryTableView: UITableView!
    
    public func customInit() {
        self.libraryTableView.delegate = self
        self.libraryTableView.dataSource = self
    }
}

extension LibraryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
