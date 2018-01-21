//
//  CGPoint+Random.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    static func random(in size: CGSize) -> CGPoint {
        return CGPoint(x: CGFloat(arc4random_uniform(UInt32(size.width))),
                       y: CGFloat(arc4random_uniform(UInt32(size.height))))
    }
}
