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
    
    private var selectedFirework = Firework.defaultSet.first {
        didSet {
            fireworkSelectorButton.setImage(selectedFirework?.thumbNailImage, for: .normal)
        }
    }
    
    private var isShowOn = false
    
    private var fireworksScene: FireworksScene?
    
    private lazy var sizingView: SizingView = SizingView()
    
    private lazy var instructionsController = InstructionsController(withInstructions: "")
    
    private let fireworksView: SKView = {
        let view = SKView()
        view.isMultipleTouchEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var colorPicker: ColorPicker = {
        let colorPicker = ColorPicker()
        colorPicker.delegate = self
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        return colorPicker
    }()
    
    private lazy var fireworkSelectorButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ClassicFireworkThumbnail"), for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(presentFireworkPickerController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var chemicalFormulaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Titanium Powder"
        label.font = UIFont(name: "Futura", size: 18)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var autoPlayButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Auto Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = .themeColor
        
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(toggleFireworksShow), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpFireworksView()
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        
        view.add(fireworksView, sizingView, colorPicker,
                 fireworkSelectorButton, chemicalFormulaLabel, autoPlayButton)
        
        fireworksView.constrainToEdges()
        
        NSLayoutConstraint.activate([// 75 75
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
            fireworkSelectorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            chemicalFormulaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            chemicalFormulaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            
            autoPlayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            autoPlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    private func setUpFireworksView() {
        fireworksScene = FireworksScene(size: CGSize(width: fireworksView.bounds.width, height: fireworksView.bounds.height))
        fireworksView.presentScene(fireworksScene)
        fireworksScene?.scaleMode = .aspectFill
        fireworksScene!.fireworksDelegate = self
    }
    
    @objc private func presentFireworkPickerController() {
        let fireworkPickerController = FireworkPickerController()
        fireworkPickerController.delegate = self
        fireworkPickerController.modalPresentationStyle = .popover
        fireworkPickerController.popoverPresentationController?.permittedArrowDirections = .down
        fireworkPickerController.popoverPresentationController?.delegate = self
        fireworkPickerController.popoverPresentationController?.sourceView = fireworkSelectorButton
        fireworkPickerController.popoverPresentationController?.sourceRect = fireworkSelectorButton.bounds
        present(fireworkPickerController, animated: true)
    }
    
    @objc private func toggleFireworksShow() {
        isShowOn ? fireworksScene?.startFireworkShow() : fireworksScene?.endFireworkShow()
        autoPlayButton.setTitle(isShowOn ? "Stop" : "Auto Play", for: .normal)
        isShowOn = !isShowOn
    }
    
    private func updateChemicalFormulaLabel(with color: UIColor) {
        let colorCompound = color.colorCompoundEquivelant()
        chemicalFormulaLabel.textColor = colorCompound.color
        chemicalFormulaLabel.text = colorCompound.chemical.rawValue
    }
}

extension FireworksViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension FireworksViewController: ColorPickerDelegate {
    func didSetColorTo(_ color: UIColor) {
        updateChemicalFormulaLabel(with: color)
    }
}


extension FireworksViewController: FireworksSceneDelegate {
    
    var currentFirework: Firework? {
        return selectedFirework
    }
    
    var fireworksColor: UIColor? {
        return colorPicker.currentColor
    }
    
    var scaleFactor: CGFloat {
        return sizingView.currentScaleFactor + 0.5
    }
    
    func didExplodeFirework(with color: UIColor) {
        if color != colorPicker.currentColor {
            updateChemicalFormulaLabel(with: color)
        }
        UIView.animate(withDuration: 0.8, animations: { [weak self] in
            guard let `self` = self else { return }
            self.chemicalFormulaLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.8, delay: 2, options: .curveEaseInOut, animations: {
                self.chemicalFormulaLabel.alpha = 0
            })
        }
    }
}

extension FireworksViewController: FireworkPickerControllerDelegate {
    func didSelectFirework(_ firework: Firework) {
        selectedFirework = firework
    }
}
