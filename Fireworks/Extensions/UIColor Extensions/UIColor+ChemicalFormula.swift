//
//  UIColor+ChemicalFormula.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

typealias ColorCompound = (color: UIColor, chemical: Chemical)

enum Chemical: String {
    case red = "SrCO3 - Strontium Carbonate"
    case orange = "CaCl2 - Calcium Chloride"
    case yellow = "NaNO3 - Sodium Nitrate"
    case green = "BaCl2 - Barium Chloride"
    case blue = "CuCl2 - Copper Chloride"
    case violet = "KNO3 - Potassium Nitrate"
    case white = "Titanium Powder"
}

extension UIColor {
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    static let colorsForCompound: [UIColor: Chemical] = [UIColor(1, 0, 0): .red, UIColor(1, 0.5, 0): .orange,
                                                         UIColor(1, 1, 0): .yellow, UIColor(0, 1, 0): .green,
                                                         UIColor(0, 0, 1): .blue, UIColor(0.5, 0, 0.5): .violet,
                                                         UIColor(1, 1, 1): .white]
}

extension UIColor {
    func colorCompoundEquivelant() -> ColorCompound {
        let sortedColors = UIColor.colorsForCompound.keys.sorted { (first, second) -> Bool in
            return first - self < second - self
        }
        let equivelantColor = sortedColors.first!
        return ColorCompound(color: equivelantColor, chemical: UIColor.colorsForCompound[equivelantColor]!)
    }
}
