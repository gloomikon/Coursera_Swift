//
//  CustomFlowLayout.swift
//  Course2Week3Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewLayout {

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var collectionViewWidth: CGFloat = UIScreen.main.bounds.width - 32
    private var collectionViewHeight: CGFloat = 0
    private let numberOfColumns = 2

    override func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else {
            return
        }

        let columnWidth = (UIScreen.main.bounds.width - 48 ) / 2

        let xOffset: [CGFloat] = [16, 32 + columnWidth] // Offset for every column
        var yOffset: [CGFloat] = .init(repeating: -16.0, count: numberOfColumns)  // Offset for every row
        var column = 0
        var column0MaxHeight: CGFloat = 0
        var columm1MaxHeight: CGFloat = 0

        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            let currentItemHeight: CGFloat = (item == 0) ? 300 : 200

            itemAttributes.frame = CGRect(x: xOffset[column], y: yOffset[column] + 16, width: columnWidth, height: currentItemHeight)

            let currentYOffset = 16 + itemAttributes.frame.size.height

            yOffset[column] += currentYOffset

            if (column == 0)  {
                column0MaxHeight += currentYOffset
            } else {
                columm1MaxHeight += currentYOffset
            }

            if (item == 1) {
                column = 1
            } else {
                column = column == 0 ? 1 : 0
            }

            cache.append(itemAttributes)
        }

        collectionViewHeight = max(column0MaxHeight, columm1MaxHeight)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
}
