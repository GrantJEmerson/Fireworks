//
//  FireworkPickerController.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/19/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

protocol FireworkPickerControllerDelegate: class {
    func didSelectFirework(_ firework: Firework)
}

class FireworkPickerController: UIViewController {
    
    // MARK: Properties
    
    public weak var delegate: FireworkPickerControllerDelegate?
    
    private let cellID = "cellID"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .themeColor
        let footerView = UIView()
        tableView.tableFooterView = footerView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        view.add(tableView)
        tableView.constrainToEdges()
    }
}

extension FireworkPickerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .themeColor
        let firework = Firework.defaultSet[indexPath.row]
        cell.imageView?.image = firework.thumbNailImage
        cell.textLabel?.text = firework.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firework = Firework.defaultSet[indexPath.row]
        delegate?.didSelectFirework(firework)
        dismiss(animated: true)
    }
}

extension FireworkPickerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Firework.defaultSet.count
    }
}
