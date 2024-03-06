//
//  DateFormatterExtension.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/19/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    var regular: UIFont { return withWeight(.regular) }
    var medium: UIFont { return withWeight(.medium) }
    var semibold: UIFont { return withWeight(.semibold) }
    var bold: UIFont { return withWeight(.bold) }
    
    static func creditCard(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Credit Card", size: size)
    }
    
    static func sfDisplay(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "SF UI Display", size: size)
    }
    
    static func theSans(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "TheSans", size: size)
    }
    
    static func modeNine(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "ModeNine", size: size)
    }
    
    static func gothamPro(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Gotham Pro", size: size)
    }
    
    static func gotham(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Gotham", size: size)
    }
    
    private func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        
        traits[.weight] = weight
        
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName
        
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

/// ["Academy Engraved LET", "Al Nile", "American Typewriter", "Apple Color Emoji", "Apple SD Gothic Neo", "Apple Symbols", "Arial", "Arial Hebrew", "Arial Rounded MT Bold", "Avenir", "Avenir Next", "Avenir Next Condensed", "Baskerville", "Bodoni 72", "Bodoni 72 Oldstyle", "Bodoni 72 Smallcaps", "Bodoni Ornaments", "Bradley Hand", "Chalkboard SE", "Chalkduster", "Charter", "Cochin", "Copperplate", "Courier", "Courier New", "Credit Card", "Damascus", "Devanagari Sangam MN", "Didot", "DIN Alternate", "DIN Condensed", "Euphemia UCAS", "Farah", "Futura", "Galvji", "Geeza Pro", "Georgia", "GeosansLight", "Gill Sans", "Gotham", "Gotham Pro", "Helvetica", "Helvetica Neue", "Hiragino Maru Gothic ProN", "Hiragino Mincho ProN", "Hiragino Sans", "Hoefler Text", "Kailasa", "Kefa", "Khmer Sangam MN", "Kohinoor Bangla", "Kohinoor Devanagari", "Kohinoor Gujarati", "Kohinoor Telugu", "Lao Sangam MN", "Malayalam Sangam MN", "Marker Felt", "Menlo", "Mishafi", "ModeNine", "Mukta Mahee", "Myanmar Sangam MN", "Noteworthy", "Noto Nastaliq Urdu", "Noto Sans Kannada", "Noto Sans Myanmar", "Noto Sans Oriya", "Optima", "Palatino", "Papyrus", "Party LET", "PingFang HK", "PingFang SC", "PingFang TC", "Rockwell", "Savoye LET", "SF UI Display", "Sinhala Sangam MN", "Snell Roundhand", "Symbol", "Tamil Sangam MN", "TheSans", "Thonburi", "Times New Roman", "Trebuchet MS", "Verdana", "Zapf Dingbats", "Zapfino"]
