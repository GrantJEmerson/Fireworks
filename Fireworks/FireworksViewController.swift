//
//  FireworksViewController.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/19/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit
import SpriteKit

class FireworksViewController: UIViewController {
    
    // MARK: Properties
    
    private let fireworksView: SKView = {
        let view = SKView()
        view.isMultipleTouchEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sizingView: SizingView = {
        let sizingView = SizingView()
        sizingView.delegate = self
        return sizingView
    }()
    
    private lazy var colorPicker: ColorPicker = {
        let colorPicker = ColorPicker()
        colorPicker.delegate = self
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        return colorPicker
    }()
    
    private lazy var fireworkSelectorButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var instructionsController = InstructionsController(withInstructions: " Hey hello")
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpFireworksView()
//        instructionsController.modalPresentationStyle = .popover
//        instructionsController.popoverPresentationController?.permittedArrowDirections = .down
//        instructionsController.popoverPresentationController?.delegate = self
//        instructionsController.popoverPresentationController?.sourceView = colorPicker
//        instructionsController.popoverPresentationController?.sourceRect = colorPicker.bounds
//        present(instructionsController, animated: true)
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        
        view.add(fireworksView, sizingView, colorPicker, fireworkSelectorButton)
        
        fireworksView.constrainToEdges()
        
        NSLayoutConstraint.activate([
            sizingView.heightAnchor.constraint(equalToConstant: 200),
            sizingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sizingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            colorPicker.leadingAnchor.constraint(equalTo: sizingView.trailingAnchor),
            colorPicker.heightAnchor.constraint(equalToConstant: 200),
            colorPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            colorPicker.widthAnchor.constraint(equalTo: colorPicker.heightAnchor),
            
            fireworkSelectorButton.heightAnchor.constraint(equalToConstant: 200),
            fireworkSelectorButton.widthAnchor.constraint(equalTo: fireworkSelectorButton.heightAnchor),
            fireworkSelectorButton.leadingAnchor.constraint(equalTo: colorPicker.trailingAnchor, constant: 10),
            fireworkSelectorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    private func setUpFireworksView() {
        let fireworksScene = FireworksScene(size: CGSize(width: fireworksView.bounds.width, height: fireworksView.bounds.height))
        fireworksView.presentScene(fireworksScene)
        fireworksScene.scaleMode = .aspectFill
        fireworksScene.fireworksDelegate = self
    }
}

extension FireworksViewController: SizingViewDelegate {
    func scaleFactorSetTo(_ scale: CGFloat) {
    }
}

extension FireworksViewController: ColorPickerDelegate {
    func didSetColorTo(_ color: UIColor) {
    }
}

extension FireworksViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension FireworksViewController: FireworksSceneDelegate {
    
    var fireworksColor: UIColor? {
        return colorPicker.currentColor
    }
}
