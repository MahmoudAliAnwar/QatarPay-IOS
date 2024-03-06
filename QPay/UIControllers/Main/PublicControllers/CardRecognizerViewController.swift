//
//  CardRecognizerViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/9/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import PayCardsRecognizer

class CardRecognizerViewController: ViewController, PayCardsRecognizerPlatformDelegate {
    
    var recognizer: PayCardsRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recognizer = PayCardsRecognizer(delegate: self, resultMode: .sync, container: self.view, frameColor: .green)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recognizer.startCamera()
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        recognizer.stopCamera()
    }
    
    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        let card1 = result.recognizedNumber // Card number
        let card2 = result.recognizedHolderName // Card holder
        let card3 = result.recognizedExpireDateMonth // Expire month
        let card4 = result.recognizedExpireDateYear // Expire year
        
        if result.isCompleted {
//            performSegue(withIdentifier: "CardDetailsViewController", sender: result)

            let card = "Card \(card1 ?? "") \(card2 ?? "") \(card3 ?? "") \(card4 ?? "")"
            print(card)
        } else {

        }
        
    }
}
