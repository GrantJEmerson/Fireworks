//
//  CultureViewController.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

class CulturalExplorationViewController: UIViewController {
    
    // MARK: Properties
    
    private let cellID = "cellID"
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissCultureViewController))
        return doneBarButtonItem
    }()
    
    private lazy var customLayout: CultureCollectionViewLayout = {
        let layout = CultureCollectionViewLayout()
        layout.delegate = self
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(CultureExplorationCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSubviews()
        setUpNavigation()
    }
    
    // MARK: Selector Functions
    
    @objc private func dismissCultureViewController() {
        dismiss(animated: true)
    }
    
    // MARK: Private Functions
    
    private func setUpSubviews() {
        view.add(collectionView)
        collectionView.constrainToEdges()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Fireworks in Culture"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
}

extension CulturalExplorationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CultureExplorationCollectionViewCell
        cell.country = Country.all[indexPath.item]
        cell.delegate = self
        return cell
    }
}

extension CulturalExplorationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Country.all.count
    }
}

extension CulturalExplorationViewController: CulturalExplorationLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightAt indexPath: IndexPath) -> CGFloat {
        let image = Country.all[indexPath.item].flag
        let widthToHeightFactor = image.size.height / image.size.width
        let width = view.bounds.width / 4
        let height = width * widthToHeightFactor
        return height
    }
}

extension CulturalExplorationViewController: CultureExplorationCellDelegate {
    func updateLayout(for cell: CultureExplorationCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let newState = cell.isOpen ? CellState.open : .closed
        customLayout.cellTransformation = CellTransformation(indexPath: indexPath, state: newState)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}
