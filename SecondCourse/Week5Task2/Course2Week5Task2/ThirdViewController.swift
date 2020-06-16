//
//  ThirdViewController.swift
//  Course2Week5Task2
//
//  Created by Nikolay Zhurba on 06.04.2020.
//  Copyright © 2020 mzhurba. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var textLabel: UILabel!

    // MARK: - Private properties

    private var text: String?

    // MARK: - Life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textLabel.text = text
        textLabel.sizeToFit()
    }

    // MARK: - Public functions

    func configure(with text: String?) {
        self.text = text
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoSecondVC", sender: nil)
    }
}
