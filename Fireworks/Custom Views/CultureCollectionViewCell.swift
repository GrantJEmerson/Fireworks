//
//  CultureCollectionViewCell.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

class CultureCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    public var country: Country? {
        didSet {
            guard let country = country else { return }
            flagImageView.image = country.flag
            factLabel.text = country.fact
        }
    }
    
    private var isOpen = false
    
    private var flagImageViewWidthConstraint: NSLayoutConstraint?
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var factLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isOpen = !isOpen
        flagImageViewWidthConstraint?.constant = isOpen ? 0 : bounds.width
        UIView.animate(withDuration: 0.8) { [weak self] in
            guard let `self` = self else { return }
            self.layoutIfNeeded()
        }
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        add(flagImageView, factLabel)
        
        flagImageViewWidthConstraint = flagImageView.widthAnchor.constraint(equalToConstant: bounds.width)
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: topAnchor),
            flagImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flagImageViewWidthConstraint!,
            
            factLabel.topAnchor.constraint(equalTo: topAnchor),
            factLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            factLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor),
            factLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
