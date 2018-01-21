//
//  CGFloat+Positive.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    var positive: CGFloat {
        var value = self
        if value < 0 {
            value *= -1
        }
        return value
    }
}
