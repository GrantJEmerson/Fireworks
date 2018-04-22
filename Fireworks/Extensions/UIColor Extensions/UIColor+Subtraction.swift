//
//  UIColor+Subtraction.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

extension UIColor {
    static func - (left: UIColor, right: UIColor) -> CGFloat {
        let leftComponents = left.cgColor.components!
        let rightComponents = right.cgColor.components!
        let red = (leftComponents[0] - rightComponents[0]).positive
        let green = (leftComponents[1] - rightComponents[1]).positive
        let blue = (leftComponents[2] - rightComponents[2]).positive
        return red + blue + green
    }
}
