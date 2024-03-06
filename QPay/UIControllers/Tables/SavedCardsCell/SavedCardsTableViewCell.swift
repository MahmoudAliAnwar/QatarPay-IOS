//
//  SavedCardsTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 26/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol SavedCardsTableViewCellDelegate: AnyObject {
    
    func didTapDeleteSavedCard (_ cell : SavedCardsTableViewCell ,for card: TokenizedCard )
    func didTapSetDefaultCard  (_ cell : SavedCardsTableViewCell ,for card: TokenizedCard )
}

class SavedCardsTableViewCell: UITableViewCell {
 
    @IBOutlet weak var cardNumberLabel     : UILabel!
    @IBOutlet weak var cardTypeLabel       : UILabel!
    @IBOutlet weak var setDefaultStackView : UIStackView!
    
    
    var delegate : SavedCardsTableViewCellDelegate?
    
    var object: TokenizedCard! {
        willSet {
            guard let data = newValue else { return }
            
            self.cardNumberLabel.text         = data._cardNumber
            self.cardTypeLabel.text           = data._cardType
            self.setDefaultStackView.isHidden = data._isDefault
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

extension SavedCardsTableViewCell {
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.delegate?.didTapDeleteSavedCard(self, for: self.object )
    }
    
    @IBAction func setDefaultAction(_ sender: UIButton) {
        self.delegate?.didTapSetDefaultCard(self, for: self.object)
    }
}
