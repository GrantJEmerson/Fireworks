//
//  SizingView.swift
//  SizingView
//
//  Created by Grant Emerson on 1/18/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

public protocol SizingViewDelegate: class {
    func scaleFactorSetTo(_ scale: CGFloat)
}

class SizingView: UIView {
    
    // MARK: Properties
    
    public weak var delegate: SizingViewDelegate?
        
    public private(set) var currentScaleFactor: CGFloat = 0.5
    
    private let IndicatorLabel: ((_ text: String) -> UILabel) = { text in
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private lazy var smallIndicatorLabel = IndicatorLabel("S")
    private lazy var mediumIndicatorLabel = IndicatorLabel("M")
    private lazy var largeIndicatorLabel = IndicatorLabel("L")
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "SizingViewCover"))
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3125).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        let endColor = UIColor(red: 0.894, green: 1.000, blue: 0.894, alpha: 1.000)
        let gradient = CGGradient(colorsSpace: nil,
                                  colors: [UIColor.green.cgColor, endColor.cgColor] as CFArray,
                                  locations: [0, 0.8])!
        let drawingRect = CGRect(x: 15, y: 0, width: rect.width - 15, height: rect.height)
        let rectanglePath = UIBezierPath(rect: drawingRect)
        context.saveGState()
        rectanglePath.addClip()
        context.drawLinearGradient(gradient, start: CGPoint(x: rect.midX, y: rect.height - min(currentScaleFactor * rect.height, rect.height)), end: CGPoint(x: rect.midX, y: rect.maxY), options: [])
        context.restoreGState()
    }
    
    // MARK: Touch
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateGradient(with: touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        updateGradient(with: touch)
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        add(coverImageView, smallIndicatorLabel, mediumIndicatorLabel, largeIndicatorLabel)
        
        NSLayoutConstraint.activate([
            smallIndicatorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            smallIndicatorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            smallIndicatorLabel.widthAnchor.constraint(equalToConstant: 15),
            
            mediumIndicatorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            mediumIndicatorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            largeIndicatorLabel.topAnchor.constraint(equalTo: topAnchor),
            largeIndicatorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            coverImageView.leadingAnchor.constraint(equalTo: smallIndicatorLabel.trailingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateGradient(with touch: UITouch) {
        let touchLocation = touch.location(in: self)
        currentScaleFactor = (bounds.size.height - touchLocation.y) / bounds.size.height
        delegate?.scaleFactorSetTo(currentScaleFactor)
        setNeedsDisplay()
    }
}
