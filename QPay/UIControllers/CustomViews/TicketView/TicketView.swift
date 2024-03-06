//
//  TicketView.swift
//  QPay
//
//  Created by Mohammed Hamad on 23/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class TicketView: ViewDesign {
    
    final var separatorView: DashedView = {
        let view = DashedView()
        return view
    }()
    
    var includedView: UIView? {
        didSet {
            self.addSubview(self.includedView!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.drawTicket()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 18
    }
    
    private func drawTicket() {
        let ticketShapeLayer = CAShapeLayer()
        ticketShapeLayer.frame = self.bounds
        ticketShapeLayer.fillColor = UIColor.white.cgColor
        
        let ticketShapePath = UIBezierPath(roundedRect: ticketShapeLayer.bounds, cornerRadius: 18)
        
        //        let topLeftArcPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 100),
        //                                          radius: 36 / 2,
        //                                          startAngle:  CGFloat(Double.pi / 2),
        //                                          endAngle: CGFloat(Double.pi + Double.pi / 2),
        //                                          clockwise: false)
        //        topLeftArcPath.close()
        //
        //        let topRightArcPath = UIBezierPath(arcCenter: CGPoint(x: ticketShapeLayer.frame.width, y: 100),
        //                                           radius: 36 / 2,
        //                                           startAngle:  CGFloat(Double.pi / 2),
        //                                           endAngle: CGFloat(Double.pi + Double.pi / 2),
        //                                           clockwise: true)
        //        topRightArcPath.close()
        
        let bottomLeftArcPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: frame.height - 200),
                                             radius: 36 / 2,
                                             startAngle:  CGFloat(Double.pi / 2),
                                             endAngle: CGFloat(Double.pi + Double.pi / 2),
                                             clockwise: false)
        bottomLeftArcPath.close()
        
        let seperatorX = frame.origin.x + 20
        self.separatorView.frame = CGRect(x: seperatorX,
                                          y: frame.height - 200,
                                          width: self.width - (seperatorX * 2),
                                          height: 2)
        
        let bottomRightArcPath = UIBezierPath(arcCenter: CGPoint(x: ticketShapeLayer.frame.width, y: frame.height - 200),
                                              radius: 36 / 2,
                                              startAngle:  CGFloat(Double.pi / 2),
                                              endAngle: CGFloat(Double.pi + Double.pi / 2),
                                              clockwise: true)
        bottomRightArcPath.close()
        
        //        ticketShapePath.append(topLeftArcPath)
        //        ticketShapePath.append(topRightArcPath.reversing())
        ticketShapePath.append(bottomLeftArcPath)
        ticketShapePath.append(bottomRightArcPath.reversing())
        
        ticketShapeLayer.path = ticketShapePath.cgPath
        
        self.layer.addSublayer(ticketShapeLayer)
        self.layer.addSublayer(self.separatorView.layer)
        
        ticketShapeLayer.zPosition = 1
        self.separatorView.layer.zPosition = 2
        self.includedView?.layer.zPosition = 3
        
        // Add elevation
        self.shadowColor = .darkGray
        self.shadowOpacity = 0.3
        self.shadowRadius = 8
        self.shadowOffset = CGSize(width: 0, height: 4)
    }
}
