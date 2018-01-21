//
//  GradientView.swift
//  NewSliderBar
//
//  Created by Grant Emerson on 1/18/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    // MARK: Properties
    
    open var startingColor: UIColor = .white {
        didSet { setNeedsDisplay() }
    }
    
    open var endingColor: UIColor = .black {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
            let gradient = CGGradient(colorsSpace: nil, colors: [startingColor.cgColor, endingColor.cgColor] as CFArray, locations: [0, 1]) else { return }
        let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.height / 2)
        context.saveGState()
        rectanglePath.addClip()
        let startPoint = CGPoint(x: bounds.minX, y: bounds.midY)
        let endPoint = CGPoint(x: bounds.maxX, y: bounds.midY)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
    }
}
