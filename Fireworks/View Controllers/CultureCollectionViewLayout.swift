//
//  CultureCollectionViewLayout.swift
//  Fireworks
//
//  Created by Grant Emerson on 1/22/18.
//  Copyright © 2018 Grant Emerson. All rights reserved.
//

import UIKit

protocol CulturalExplorationLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightAt indexPath:IndexPath) -> CGFloat
}

public enum CellState {
    case open, closed
}

typealias CellTransformation = (indexPath: IndexPath, state: CellState)

class CultureCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: Properties
    
    public var cellTransformation: CellTransformation?
    
    public weak var delegate: CulturalExplorationLayoutDelegate?
    
    private var columns = 4
    private var padding: CGFloat = 2
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: Override Layout Functions
    
    override func prepare() {
        guard cache.isEmpty || cellTransformation != nil,
            let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(columns)
        var xOffset = [CGFloat]()
        for column in 0 ..< columns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: columns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            guard var flagHeight = delegate?.collectionView(collectionView, heightAt: indexPath) else { continue }
            if indexPath == cellTransformation?.indexPath {
                flagHeight *= cellTransformation?.state == .open ? 2 : 1
            }
            let height = padding * 2 + flagHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: padding, dy: padding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (columns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter({ return $0.frame.intersects(rect) })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
