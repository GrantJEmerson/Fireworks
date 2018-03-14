//
//  CGFloat+RandomDecimal.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static var randomDecimal: CGFloat {
        return CGFloat(arc4random_uniform(100))/100
    }
    static func random(from lowerBound: CGFloat = 0, to higherBound: CGFloat) -> CGFloat {
        return lowerBound + CGFloat(arc4random_uniform(UInt32(higherBound)))
    }
}
