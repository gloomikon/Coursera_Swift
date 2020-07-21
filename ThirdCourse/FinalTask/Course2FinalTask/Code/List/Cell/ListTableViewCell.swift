//
//  LikeTableViewCell.swift
//  Course2FinalTask
//
//  Created by Nikolay Zhurba on 25.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ListTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!

    // MARK: - Configure

    func configure(with user: User) {
        avatarImageView.image = user.avatar
        usernameLabel.text = user.fullName

        self.selectionStyle = .none
    }
}
