//
//  CultureExplorationCollectionViewCell.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

protocol CultureExplorationCellDelegate: class {
    func updateLayout(for cell: CultureExplorationCollectionViewCell)
}

class CultureExplorationCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    public var country: Country? {
        didSet {
            guard let country = country else { return }
            flagImageView.image = country.flag
            factLabel.text = country.fact
        }
    }
    
    public weak var delegate: CultureExplorationCellDelegate?
    
    public private(set) var isOpen = false
    
    private var flagImageViewWidthConstraint: NSLayoutConstraint?
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var factLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = -1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleFacts))
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSubviews()
    }
    
    // MARK: Selector Functions
    
    @objc private func toggleFacts() {
        isOpen = !isOpen
        flagImageViewWidthConstraint?.constant = isOpen ? 0 : bounds.width
        delegate?.updateLayout(for: self)
        UIView.animate(withDuration: 0.8) { [weak self] in
            guard let `self` = self else { return }
            self.layoutIfNeeded()
        }
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        addGestureRecognizer(tapGestureRecognizer)
        add(flagImageView, factLabel)
        
        flagImageViewWidthConstraint = flagImageView.widthAnchor.constraint(equalToConstant: bounds.width)
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(equalTo: topAnchor),
            flagImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flagImageViewWidthConstraint!,
            
            factLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            factLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            factLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor),
            factLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
