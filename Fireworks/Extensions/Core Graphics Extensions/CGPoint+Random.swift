//
//  CGPoint+Random.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    static func random(in bounds: CGRect) -> CGPoint {
        let widthSegment = bounds.width / 4
        let heightSegment = bounds.height / 4
        return CGPoint(x: CGFloat.random(from: bounds.minX + widthSegment / 2, to: widthSegment * 3),
                       y: CGFloat.random(from: bounds.minY + heightSegment / 2, to: heightSegment * 3))
    }
}
