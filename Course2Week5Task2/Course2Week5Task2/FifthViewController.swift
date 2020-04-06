//
//  FifthViewController.swift
//  Course2Week5Task2
//
//  Created by Nikolay Zhurba on 06.04.2020.
//  Copyright © 2020 mzhurba. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController {

    // MARK: - Properties

    var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        view.addSubview(backButton)
        setLayout()
    }

    // MARK: - Functions

    private func setLayout() {
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func backButtonPressed (_ sender: UIButton) {
        self.didMove(toParent: self.parent)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
