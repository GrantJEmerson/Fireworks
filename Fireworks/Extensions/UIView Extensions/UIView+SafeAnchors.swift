//
//  UIView+SafeAnchors.swift
//  Fireworks
//
//  Created by Grant Emerson on 4/22/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

extension UIView {
    var safeAnchors: UILayoutGuide? {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide
        }
        return nil
    }
}
