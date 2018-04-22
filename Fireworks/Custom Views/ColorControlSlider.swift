//
//  ColorControlSlider.swift
//  NewSliderBar
//
//  Created by Grant Emerson on 1/18/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

protocol ColorControlSliderDelegate: class {
    func colorControlSlider(_ colorControlSlider: ColorControlSlider, didChangeTo value: CGFloat)
}

class ColorControlSlider: UISlider {
    
    // MARK: Properties
    
    public weak var delegate: ColorControlSliderDelegate?
    
    open var color: UIColor {
        didSet { gradientView.endingColor = color }
    }
    
    private lazy var gradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.startingColor = .black
        gradientView.endingColor = color
        gradientView.backgroundColor = .clear
        gradientView.isUserInteractionEnabled = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    // MARK: Init
    
    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
        setUpSlider()
        setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initilization with NSCoder not yet implemented.")
    }
    
    // MARK: Private Functions
    
    private func setUpSlider() {
        setThumbImage(UIImage(named: "ColorSliderThumbImage"), for: .normal)
        addTarget(self, action: #selector(updateColor), for: .valueChanged)
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear
    }
    
    private func setUpSubviews() {
        insertSubview(gradientView, at: 0)
        gradientView.constrainToEdges()
    }
    
    @objc private func updateColor() {
        delegate?.colorControlSlider(self, didChangeTo: CGFloat(value))
    }
    
}
