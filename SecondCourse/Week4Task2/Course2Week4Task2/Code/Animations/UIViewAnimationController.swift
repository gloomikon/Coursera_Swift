//
//  UIViewAnimationController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class UIViewAnimationController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var flipButton: UIButton!

    // MARK: - IBActions
    
    @IBAction func animationViewTapHandler(sender: UITapGestureRecognizer) {
        animateOrangeView()
    }
    
    @IBAction func flipButtonTapHandler(sender: UIButton) {
        startFlipAnimation()
    }

    // MARK: - Private functions

    private func animateOrangeView() {
        UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseInOut], animations: {
            let halfwidth = self.animationView.frame.width / 2
            self.animationView.center.x = self.view.frame.width - halfwidth
            self.animationView.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        })
    }

    private func startFlipAnimation() {
        let originState = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
        var shouldApplyOriginalState = false
        let angled = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        let angledBack = CGAffineTransform(rotationAngle: CGFloat(Float.pi * 2))
        UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseInOut], animations: {
            if self.view.transform == originState {
                self.view.transform = angled
                self.flipButton.transform = angled
            } else {
                self.view.transform = angledBack
                self.flipButton.transform = angledBack
                shouldApplyOriginalState = true
            }
        })

        if shouldApplyOriginalState {
            view.transform = originState
        }
    }
}
