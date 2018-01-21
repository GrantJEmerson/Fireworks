//
//  FireworkPickerController.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/19/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

public protocol FireworksViewControllerDelegate: class {
    
}

class FireworkPickerController: UIViewController {
    
    // MARK: Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        view.add(tableView)
        tableView.constrainToEdges()
    }

}
