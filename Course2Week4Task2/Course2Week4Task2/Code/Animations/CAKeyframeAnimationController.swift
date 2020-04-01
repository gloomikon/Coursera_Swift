//
//  CAKeyframeAnimationController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CAKeyframeAnimationController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var startShakeAnimationButton: UIButton!
    @IBOutlet weak var startSinAnimationButton: UIButton!
    
    @IBAction func shakeAnimationTapHandler(sender: UIButton) {
        shakeAnimation()
    }

    @IBAction func sinAnimationTapHandler(sender: UIButton) {
        sinAnimation()
    }

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSinPath()
    }

    // MARK: - Private functions

    private func shakeAnimation() {
        let const = passcodeTextField.center.x
        let xPositions = [0 + const, 10 + const, -10 + const, 10 + const, -5 + const, 5 + const, -5 + const, 0 + const]
        let timeFrames: [NSNumber] = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.8, 1]
        let shakeIt = CAKeyframeAnimation(keyPath: "position.x")
        shakeIt.values = xPositions
        shakeIt.keyTimes = timeFrames
        shakeIt.duration = 0.4

        passcodeTextField.layer.add(shakeIt, forKey: nil)
    }

    private func sinAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = sinPath()
        animation.duration = 6.0
        animation.repeatCount = .infinity
        animation.rotationMode = .rotateAuto
        orangeView.layer.add(animation, forKey: nil)
    }
}

extension CAKeyframeAnimationController {
    private func showSinPath() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = sinPath()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    private func sinPath() -> CGPath {
        let startPoint = orangeView.center
        let width = self.view.bounds.width - 2 * startPoint.x
        let height = self.view.bounds.height / 6.0
        return CGPath.sinPath(startPoint: startPoint, width: width, height: height, periods: 1.5)
    }
}
