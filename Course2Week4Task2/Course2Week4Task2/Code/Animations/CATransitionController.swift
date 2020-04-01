//
//  CATransitionController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CATransitionController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var textLabel: UILabel!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(swipeGestureRecognizer)
    }

    // MARK: - IBActions

    @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        startTransitionAnimation()
    }

    // MARK: - Private functions

    private func startTransitionAnimation() {
        let animation = CATransition()
        animation.type = .moveIn
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self
        textLabel.layer.add(animation, forKey: "transition")
        textLabel.textColor = .green
        textLabel.text = "Sliding!"
    }

    private func startFadeAnimation() {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        textLabel.layer.add(animation, forKey: nil)
        textLabel.textColor = .orange
        textLabel.text = "Initial Text!"
    }
}

// MARK: - CAAnimationDelegate

extension CATransitionController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        textLabel.layer.removeAnimation(forKey: "transition")
        startFadeAnimation()
    }
}
