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
    
    private let DefaultButton: () -> (UIButton) = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = .themeColor
        
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private lazy var autoPlayButton: UIButton = {
        let button = DefaultButton()
        button.setTitle("Auto Play", for: .normal)
        button.addTarget(self, action: #selector(toggleFireworksShow), for: .touchUpInside)
        return button
    }()
    
    private lazy var aboutCultureButton: UIButton = {
        let button = DefaultButton()
        button.setTitle("Cultural Exploration", for: .normal)
        button.addTarget(self, action: #selector(presentCultureViewConroller), for: .touchUpInside)
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
    
    // MARK: Selector Methods
    
    @objc private func presentFireworkPickerController() {
        let fireworkPickerController = FireworkPickerController()
        fireworkPickerController.delegate = self
        fireworkPickerController.modalPresentationStyle = .popover
        fireworkPickerController.popoverPresentationController?.permittedArrowDirections = .down
        fireworkPickerController.popoverPresentationController?.delegate = self
        fireworkPickerController.popoverPresentationController?.sourceView = fireworkSelectorButton
        fireworkPickerController.popoverPresentationController?.sourceRect = fireworkSelectorButton.bounds
        fireworkPickerController.preferredContentSize.height = 180
        present(fireworkPickerController, animated: true)
    }
    
    @objc private func presentCultureViewConroller() {
        let cultureVC = UINavigationController(rootViewController: CultureViewController())
        self.present(cultureVC, animated: true)
    }
    
    @objc private func toggleFireworksShow() {
        isShowOn ? fireworksScene?.endFireworkShow() : fireworksScene?.startFireworkShow()
        autoPlayButton.setTitle(isShowOn ? "Auto Play" : "Stop", for: .normal)
        isShowOn = !isShowOn
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        
        view.add(fireworksView, sizingView, colorPicker,
                 fireworkSelectorButton, chemicalFormulaLabel,
                 autoPlayButton, aboutCultureButton)
        
        fireworksView.constrainToEdges()
        
        var controlWidth = view.bounds.width / 4
        if controlWidth > 200 { controlWidth = 200 }
        
        NSLayoutConstraint.activate([
            sizingView.heightAnchor.constraint(equalToConstant: controlWidth),
            sizingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sizingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            colorPicker.leadingAnchor.constraint(equalTo: sizingView.trailingAnchor),
            colorPicker.heightAnchor.constraint(equalToConstant: controlWidth),
            colorPicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            colorPicker.widthAnchor.constraint(equalTo: colorPicker.heightAnchor),
            
            fireworkSelectorButton.heightAnchor.constraint(equalToConstant: controlWidth),
            fireworkSelectorButton.widthAnchor.constraint(equalTo: fireworkSelectorButton.heightAnchor),
            fireworkSelectorButton.leadingAnchor.constraint(equalTo: colorPicker.trailingAnchor, constant: 10),
            fireworkSelectorButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            chemicalFormulaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            chemicalFormulaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            
            autoPlayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            autoPlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            autoPlayButton.widthAnchor.constraint(equalToConstant: 150),
            autoPlayButton.leadingAnchor.constraint(greaterThanOrEqualTo: fireworkSelectorButton.trailingAnchor),
            
            aboutCultureButton.bottomAnchor.constraint(equalTo: autoPlayButton.topAnchor, constant: -10),
            aboutCultureButton.centerXAnchor.constraint(equalTo: autoPlayButton.centerXAnchor),
            aboutCultureButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setUpFireworksView() {
        fireworksScene = FireworksScene(size: CGSize(width: fireworksView.bounds.width, height: fireworksView.bounds.height))
        fireworksView.presentScene(fireworksScene)
        fireworksScene?.scaleMode = .aspectFill
        fireworksScene!.fireworksDelegate = self
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
