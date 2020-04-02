//
//  UIViewPropertyAnimatorController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class UIViewPropertyAnimatorController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var animationView: UIView!

    // MARK: - Private properties

    private var animator: UIViewPropertyAnimator!

    // MARK: - IBActions

    @IBAction func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

        switch recognizer.state {
        case .began:
            animator = UIViewPropertyAnimator(duration: 5, timingParameters: UISpringTimingParameters(mass: 2.0, stiffness: 30.0, damping: 7.0, initialVelocity: .zero))
            animator.addAnimations {
                self.animationView.center.x += 300
                self.animationView.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi)).concatenating(transform)
            }
            animator.pauseAnimation()
        case .changed:
            animator.fractionComplete = recognizer.translation(in: view).x / view.bounds.size.width
        case .ended:
            if self.view.center.x > recognizer.translation(in: view).x {
                animator.isReversed = true
            }
            animator.startAnimation()
        default:
            break
        }
    }
}
