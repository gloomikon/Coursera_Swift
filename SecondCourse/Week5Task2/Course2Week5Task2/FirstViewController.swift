//
//  ViewController.swift
//  Course2Week5Task2
//
//  Created by Nikolay Zhurba on 06.04.2020.
//  Copyright © 2020 mzhurba. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet var textField: UITextField!

    @IBAction func buttonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoThirdVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ThirdViewController  {
            vc.configure(with: textField.text)
        }
    }
}

