//
//  UIView+addSubviews.swift
//  NewSliderBar
//
//  Created by Grant Emerson on 1/18/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

extension UIView {
    func add(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
