//
//  UIViewController+PresentAsPopUp.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/23/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentPopUp(_ viewController: UIViewController, withHeight height: CGFloat, by source: UIView) {
        guard let `self` = self as? UIPopoverPresentationControllerDelegate else { return }
        viewController.modalPresentationStyle = .popover
        viewController.popoverPresentationController?.permittedArrowDirections = .down
        viewController.popoverPresentationController?.delegate = self
        viewController.popoverPresentationController?.sourceView = source
        viewController.popoverPresentationController?.sourceRect = source.bounds
        viewController.preferredContentSize.height = height
        present(viewController, animated: true)
    }
}
