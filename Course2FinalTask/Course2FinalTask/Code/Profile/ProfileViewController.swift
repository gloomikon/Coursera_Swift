//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Nikolay Zhurba on 20.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileViewController: UIViewController {

    @IBOutlet var text: UILabel!

    var userId = DataProviders.shared.usersDataProvider.currentUser().id

    override func viewDidLoad() {
        super.viewDidLoad()
        text.text = DataProviders.shared.usersDataProvider.user(with: userId)?.fullName
    }
}
