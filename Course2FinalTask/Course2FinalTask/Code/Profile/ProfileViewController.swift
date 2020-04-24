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
        tabBarController?.title = "Profile"
        text.text = DataProviders.shared.usersDataProvider.user(with: userId)?.fullName

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
