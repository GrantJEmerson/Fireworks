//
//  NSLayoutContraint+ConstrainToEdges.swift
//  NewSliderBar
//
//  Created by Grant Emerson on 1/18/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

extension UIView {
    func constrainToEdges() {
        guard let parent = superview else { return }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            topAnchor.constraint(equalTo: parent.topAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    }
}
