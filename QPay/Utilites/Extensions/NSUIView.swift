//
//  NSUIView.swift
//  QPay
//
//  Created by mahmoud ali on 08/01/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import Foundation
import Charts

extension NSUIView{
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {

           if edges.contains(.all) {
               layer.borderWidth = width
               layer.borderColor = color.cgColor
           } else {
               let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]

               for edge in allSpecificBorders {
                   if let v = viewWithTag(Int(edge.rawValue)) {
                       v.removeFromSuperview()
                   }

                   if edges.contains(edge) {
                       let v = UIView()
                       v.tag = Int(edge.rawValue)
                       v.backgroundColor = color
                       v.translatesAutoresizingMaskIntoConstraints = false
                       addSubview(v)

                       var horizontalVisualFormat = "H:"
                       var verticalVisualFormat = "V:"

                       switch edge {
                       case UIRectEdge.bottom:
                           horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                           verticalVisualFormat += "[v(\(width))]-(0)-|"
                       case UIRectEdge.top:
                           horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                           verticalVisualFormat += "|-(0)-[v(\(width))]"
                       case UIRectEdge.left:
                           horizontalVisualFormat += "|-(0)-[v(\(width))]"
                           verticalVisualFormat += "|-(0)-[v]-(0)-|"
                       case UIRectEdge.right:
                           horizontalVisualFormat += "[v(\(width))]-(0)-|"
                           verticalVisualFormat += "|-(0)-[v]-(0)-|"
                       default:
                           break
                       }

                       self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                       self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                   }
               }
           }
       }

}
