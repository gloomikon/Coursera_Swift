//
//  ViewController.swift
//  Course2Week5Task1
//
//  Created by Nikolay Zhurba on 05.04.2020.
//  Copyright © 2020 mzhurba. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private var launchTimeTitleLabel: UILabel! {
        didSet {
            launchTimeTitleLabel.font = .systemFont(ofSize: 17)
            launchTimeTitleLabel.textColor = .black
            launchTimeTitleLabel.text = "Launch time:"
        }
    }

    @IBOutlet private var launchTime: UILabel! {
        didSet {
            launchTime.font = .systemFont(ofSize: 17)
            launchTime.textColor = .black
        }
    }

    @IBOutlet private var appearanceTimeTitleLabel: UILabel! {
        didSet {
            appearanceTimeTitleLabel.font = .systemFont(ofSize: 17)
            appearanceTimeTitleLabel.textColor = .black
            appearanceTimeTitleLabel.text = "Appearance time:"
        }
    }

    @IBOutlet private var appearanceTimeLabel: UILabel! {
        didSet {
            appearanceTimeLabel.font = .systemFont(ofSize: 17)
            appearanceTimeLabel.textColor = .black
        }
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLaunchTimeLabel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateAppearanceTimeLabel()
    }

    // MARK: - Private functions

    private func updateLaunchTimeLabel() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: date)
        launchTime.text = dateString
    }

    private func updateAppearanceTimeLabel() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: date)
        appearanceTimeLabel.text = dateString
    }

    // MARK: - IBActions

    @IBAction private func updateButtonTapped(_ sender: UIBarButtonItem) {
        updateAppearanceTimeLabel()
    }

    @IBAction private func pushButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

