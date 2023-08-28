//
//  PositionDataTableCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol PositionDataTableCellDelegate : AnyObject {
    func onTapDefault(_ cell : PositionDataTableCell)
    func onTapEdit   (_ cell : PositionDataTableCell)
}

class PositionDataTableCell: UITableViewCell {
    
    @IBOutlet private weak var firstLabel: UILabel!
    
    @IBOutlet private weak var secondLabel: UILabel!
    
    @IBOutlet private weak var cityLabel: UILabel!
    
    @IBOutlet private weak var countryLabel: UILabel!

    @IBOutlet private weak var defaultBtn : UIButton!
    
    
    weak var delegate : PositionDataTableCellDelegate?
    
    var type : TypeCell = .currentJob
    
    enum TypeCell: CaseIterable {
        case currentJob
        case previousJob
        case education
    }
    
    struct Data {
        let id           : Int
        let firstLabel   : String
        let secondLabel  : String
        let countryLabel : String
        let cityLabel    : String
        let startDate    : String
        let endDate      : String
        let isJobDefault : Bool
    
    }
    
    var object: Data? {
        willSet {
            guard let data         = newValue else { return }
            self.firstLabel.text   = data.firstLabel
            self.secondLabel.text  = data.secondLabel
            self.countryLabel.text = data.countryLabel
            self.cityLabel.text    = data.cityLabel
            self.defaultBtn.backgroundColor = data.isJobDefault ? UIColor(named: "green") : .gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension PositionDataTableCell {
    @IBAction func defaultAction(_ sender : ButtonDesign){
        self.delegate?.onTapDefault(self)
    }
    
    @IBAction func editAction(_ sender : UIButton){
        self.delegate?.onTapEdit(self)
    }
}

class PositionDataTableCellAdapter {
    static func convert(_ currentJob: CurrentJob) -> PositionDataTableCell.Data {
        return PositionDataTableCell.Data(id           : currentJob._id,
                                          firstLabel   : currentJob._jobTitle,
                                          secondLabel  : currentJob._companyNamee,
                                          countryLabel : currentJob._country,
                                          cityLabel    : currentJob._city,
                                          startDate    : currentJob._jobStartDate,
                                          endDate      : "",
                                          isJobDefault : currentJob._isJobDefault
        )
    }
    
    static func convert(_ previousJob: PreviousJob) -> PositionDataTableCell.Data {
        return PositionDataTableCell.Data(id           : previousJob._id,
                                          firstLabel   : previousJob._jobtitle,
                                          secondLabel  : previousJob._companyNamee,
                                          countryLabel : previousJob._country,
                                          cityLabel    : previousJob._city,
                                          startDate    : previousJob._jobStartdate,
                                          endDate      : previousJob._previousEnddate,
                                          isJobDefault: previousJob._isJobDefault
        )
    }
    
    static func convert(_ education: Education) -> PositionDataTableCell.Data {
        return PositionDataTableCell.Data(id           : education._id,
                                          firstLabel   : education._educationUniversity,
                                          secondLabel  : education._degree,
                                          countryLabel : education._country,
                                          cityLabel    : education._city,
                                          startDate    : education._startdate,
                                          endDate      : education._enddate,
                                          isJobDefault :  education._isDefault
        )
    }
}
