//
//  StockDetailsTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 27/03/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class StockDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stockDetailsTableView: UITableView!
    
    var models = [Model]()
    
    struct Model {
        let title: String
        var values: [Value]
        
        struct Value {
            let type: ValueTypes
            var value: String
        }
    }
    
    enum ValueTypes: String, CaseIterable {
        case stock = "Stock"
        case volume = "Volume"
        case lastPrice = "Last Price"
        case valueQAR = "Value QAR"
        case change = "Change"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.stockDetailsTableView.registerNib(StockDetailsRowTableViewCell.self)
        self.stockDetailsTableView.delegate = self
        self.stockDetailsTableView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - TABLE VIEW DELEGATE

extension StockDetailsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(StockDetailsRowTableViewCell.self, for: indexPath)
        
        cell.model = self.models[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let object = self.models[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
