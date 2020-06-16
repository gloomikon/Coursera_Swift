//
//  PostCell.swift
//  Course2FinalTask
//
//  Created by Nikolay Zhurba on 25.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class PostCell: UICollectionViewCell {
    @IBOutlet private var postImage: UIImageView!

    func configure(with post: Post) {
        postImage.image = post.image
    }
}
