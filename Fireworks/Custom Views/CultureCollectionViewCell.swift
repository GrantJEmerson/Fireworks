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
    
    private var flagImageViewWidthConstraint: NSLayoutConstraint?
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var factLabel: UILabel = {
        let label = UILabel()
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
