//
//  ColorPicker.swift
//  NewSliderBar
//
//  Created by Grant Emerson on 1/18/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

public protocol ColorPickerDelegate: class {
    func didSetColorTo(_ color: UIColor)
}

class ColorPicker: UIView {
    
    // MARK: Properties
    
    public weak var delegate: ColorPickerDelegate?
    
    open var currentColor: UIColor? = .white
    
    private var currentRedValue: CGFloat = 1
    private var currentGreenValue: CGFloat = 1
    private var currentBlueValue: CGFloat = 1
    
    private let SliderContainerView: () -> (UIView) = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private lazy var redSliderContainerView = SliderContainerView()
    private lazy var greenSliderContainerView = SliderContainerView()
    private lazy var blueSliderContainerView = SliderContainerView()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 22.5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var redSlider: ColorControlSlider = {
        let slider = ColorControlSlider(frame: .zero, color: .red)
        slider.delegate = self
        slider.value = 1
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var greenSlider: ColorControlSlider = {
        let slider = ColorControlSlider(frame: .zero, color: .green)
        slider.delegate = self
        slider.value = 1
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var blueSlider: ColorControlSlider = {
        let slider = ColorControlSlider(frame: .zero, color: .blue)
        slider.delegate = self
        slider.value = 1
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        UIView.animate(withDuration: 2) {
            self.redSlider.transform = self.redSlider.transform.rotated(by: (.pi / 2) * 2.5)
            self.greenSlider.transform = self.greenSlider.transform.rotated(by: -(.pi / 2) / 2)
            self.blueSlider.transform = self.blueSlider.transform.rotated(by: .pi / 2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        
        add(redSliderContainerView, greenSliderContainerView,
            blueSliderContainerView, colorView)
        
        redSliderContainerView.add(redSlider)
        greenSliderContainerView.add(greenSlider)
        blueSliderContainerView.add(blueSlider)
        
        NSLayoutConstraint.activate([
            redSliderContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            redSliderContainerView.trailingAnchor.constraint(equalTo: centerXAnchor),
            redSliderContainerView.topAnchor.constraint(equalTo: topAnchor),
            redSliderContainerView.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            greenSliderContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            greenSliderContainerView.leadingAnchor.constraint(equalTo: redSliderContainerView.trailingAnchor),
            greenSliderContainerView.topAnchor.constraint(equalTo: topAnchor),
            greenSliderContainerView.bottomAnchor.constraint(equalTo: centerYAnchor),
            
            blueSliderContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blueSliderContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blueSliderContainerView.topAnchor.constraint(equalTo: centerYAnchor),
            blueSliderContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            colorView.widthAnchor.constraint(equalToConstant: 45),
            colorView.heightAnchor.constraint(equalToConstant: 45),
            
            redSlider.heightAnchor.constraint(equalToConstant: 35),
            redSlider.centerYAnchor.constraint(equalTo: redSliderContainerView.centerYAnchor),
            redSlider.leadingAnchor.constraint(equalTo: redSliderContainerView.leadingAnchor, constant: 15),
            redSlider.trailingAnchor.constraint(equalTo: redSliderContainerView.trailingAnchor, constant: -15),
            
            greenSlider.heightAnchor.constraint(equalToConstant: 35),
            greenSlider.centerYAnchor.constraint(equalTo: greenSliderContainerView.centerYAnchor),
            greenSlider.leadingAnchor.constraint(equalTo: greenSliderContainerView.leadingAnchor, constant: 15),
            greenSlider.trailingAnchor.constraint(equalTo: greenSliderContainerView.trailingAnchor, constant: -15),
            
            blueSlider.heightAnchor.constraint(equalToConstant: 35),
            blueSlider.centerYAnchor.constraint(equalTo: blueSliderContainerView.centerYAnchor),
            blueSlider.centerXAnchor.constraint(equalTo: blueSliderContainerView.centerXAnchor),
            blueSlider.widthAnchor.constraint(equalTo: blueSliderContainerView.heightAnchor, multiplier: 1, constant: -30)
        ])
    }
    
    private func updateColor() {
        currentColor = UIColor(red: currentRedValue, green: currentGreenValue, blue: currentBlueValue, alpha: 1)
        colorView.backgroundColor = currentColor
        delegate?.didSetColorTo(currentColor!)
    }
}

extension ColorPicker: ColorControlSliderDelegate {
    func colorControlSlider(_ colorControlSlider: ColorControlSlider, didChangeTo value: CGFloat) {
        switch colorControlSlider.color {
        case .red:
            currentRedValue = value
        case .green:
            currentGreenValue = value
        case .blue:
            currentBlueValue = value
        default:
            break
        }
        updateColor()
    }
}
