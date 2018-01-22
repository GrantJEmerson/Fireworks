//
//  CultureViewController.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/21/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

class CultureViewController: UIViewController {
    
    // MARK: Properties
    
    private let cellID = "cellID"
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissCultureViewController))
        return barButtonItem
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = view.bounds.width / 5
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.526)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(CultureCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
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
        }
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
}

extension CultureViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CultureCollectionViewCell
        cell.country = Country.all[indexPath.item]
        return cell
    }
}

extension CultureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Country.all.count
    }
}

extension CultureViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = Country.all[indexPath.item].flag
        let widthToHeightFactor = image.size.height / image.size.width
        let width = view.bounds.width / 4
        let height = width * widthToHeightFactor
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
