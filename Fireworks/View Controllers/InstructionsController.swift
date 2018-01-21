//
//  InstructionViewController.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/19/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

class InstructionsController: UIViewController {
    
    // MARK: Properties
    
    open var instructions: String {
        didSet { instructionsTextView.text = instructions }
    }
    
    private lazy var instructionsTextView: UITextView = {
        let textView = UITextView()
        textView.text = instructions
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: Init
    
    init(withInstructions text: String = "") {
        self.instructions = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        view.add(instructionsTextView)
        instructionsTextView.constrainToEdges()
    }
}
