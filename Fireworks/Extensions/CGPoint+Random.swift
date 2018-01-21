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
        let widthSegment = size.width / 4
        let heighSegment = size.height / 4
        return CGPoint(x: CGFloat(arc4random_uniform(UInt32(widthSegment * 3))) + widthSegment / 2,
                       y: CGFloat(arc4random_uniform(UInt32(heighSegment * 3))) + widthSegment / 2)
    }
}
