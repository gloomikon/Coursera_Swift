//
//  FilterImageCell.swift
//  Course2FinalTask
//
//  Created by Nikolay Zhurba on 25.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FilterImageCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet var imageView: UIImageView!

    @IBOutlet var filterNameLabel: UILabel! {
        didSet {
            filterNameLabel.font = .systemFont(ofSize: 17)
            filterNameLabel.textColor = .black
        }
    }

    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    // MARK: - Configure

    func setFilterType(_ filterType: FilterType) {
        filterNameLabel.text = "\(filterType)"
    }

    func setFilteredImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }

        imageView.image = image
        loadingIndicator.stopAnimating()
    }
}
