//
//  QIDImageAnalyzer.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/09/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Vision

protocol QIDImageAnalyzerProtocol: AnyObject {
    func didFinishAnalyzation(with result: Result<VisionQID, Error>)
}

@available(iOS 13, *)
final class QIDImageAnalyzer {
    
    enum Candidate: Hashable {
        case number(String)
        case nationality(String)
        case expiryDate(DateComponents)
        case dobDate(DateComponents)
    }
    
    private var selectedQID = VisionQID()
    private var predictedCardInfo: [Candidate: Int] = [:]
    
    private weak var delegate: QIDImageAnalyzerProtocol?
    
    init(delegate: QIDImageAnalyzerProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Vision-related
    
    public lazy var request = VNRecognizeTextRequest(completionHandler: requestHandler)
    
    func analyze(image: CGImage) {
        let requestHandler = VNImageRequestHandler(
            cgImage: image,
            orientation: .up,
            options: [:]
        )
        
        self.selectedQID.image = UIImage(cgImage: image)
        
        do {
            try requestHandler.perform([request])
        } catch {
            let e = CreditCardScannerError(kind: .photoProcessing, underlyingError: error)
            delegate?.didFinishAnalyzation(with: .failure(e))
            delegate = nil
        }
    }
    
    lazy var requestHandler: ((VNRequest, Error?) -> Void)? = { [weak self] request, _ in
        guard let strongSelf = self else { return }
        
        let cardNumber: Regex = #"(?:\d[ -]*?){11}"#
        let day: Regex = #"(\d{2})\/\d{2}"#
        let month: Regex = #"(\d{2})\/\d{2}"#
        let year: Regex = #"\d{4}\/(\d{4})"#
//        let wordsToSkip = ["mastercard", "jcb", "visa", "express", "bank", "card", "platinum", "reward"]
        // These may be contained in the date strings, so ignore them only for names
//        let invalidNames = ["expiration", "valid", "since", "from", "until", "month", "year"]
        let nationality: Regex = #"([A-Z]{3,})"#
        
        guard let results = request.results as? [VNRecognizedTextObservation] else { return }
        
        var qidCard = VisionQID()
        
        let maxCandidates = 1
        
        for result in results {
            guard let candidate = result.topCandidates(maxCandidates).first,
                  candidate.confidence > 0.1 else {
                continue
            }
            
            let string = candidate.string
//            let containsWordToSkip = wordsToSkip.contains { string.lowercased().contains($0) }
//            if containsWordToSkip { continue }
            
            if let cardNumber = cardNumber.firstMatch(in: string)?
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "") {
                qidCard.number = cardNumber
                
                // the first capture is the entire regex match, so using the last
            } else if let year = year.captures(in: string).last.flatMap(Int.init),
                      let month = month.captures(in: string).last.flatMap(Int.init),
                      let day = day.captures(in: string).last.flatMap(Int.init) {
                qidCard.expiryDate = DateComponents(year: year, month: month, day: day)
                
            } else if let nationality = nationality.firstMatch(in: string) {
//                let containsInvalidName = invalidNames.contains { name.lowercased().contains($0) }
//                if containsInvalidName { continue }
                qidCard.nationality = nationality
                
            } else {
                continue
            }
        }
        
        // Name
        if let nationality = qidCard.nationality {
            let count = strongSelf.predictedCardInfo[.nationality(nationality), default: 0]
            strongSelf.predictedCardInfo[.nationality(nationality)] = count + 1
            if count > 2 {
                strongSelf.selectedQID.nationality = nationality
            }
        }
        // ExpireDate
        if let date = qidCard.expiryDate {
            let count = strongSelf.predictedCardInfo[.expiryDate(date), default: 0]
            strongSelf.predictedCardInfo[.expiryDate(date)] = count + 1
            if count > 2 {
                strongSelf.selectedQID.expiryDate = date
            }
        }
        
        // Number
        if let number = qidCard.number {
            let count = strongSelf.predictedCardInfo[.number(number), default: 0]
            strongSelf.predictedCardInfo[.number(number)] = count + 1
            if count > 2 {
                strongSelf.selectedQID.number = number
            }
        }
        
        if strongSelf.selectedQID.number != nil {
            strongSelf.delegate?.didFinishAnalyzation(with: .success(strongSelf.selectedQID))
            strongSelf.delegate = nil
        }
    }
}

extension VisionQID {
    // The aspect ratio of credit-card is Golden-ratio
    static let heightRatioAgainstWidth: CGFloat = 0.6180469716
}
