//
//  SecondViewController.swift
//  Course2Week5Task2
//
//  Created by Nikolay Zhurba on 06.04.2020.
//  Copyright © 2020 mzhurba. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBAction func navigateToFourthVC(_ sender: Any) {
        let vc = FourthViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @IBAction func addChildVC(_ sender: Any) {
        let vc = FifthViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    @IBAction func unwindToSecondViewController(segue: UIStoryboardSegue) { }
}
