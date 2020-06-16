//
//  ViewController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CABasicAnimationController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var orangeView: UIView! {
        didSet {
            orangeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeRound)))
        }
    }

    @IBOutlet weak var cyanView: UIView! {
        didSet {
            cyanView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeInvisible)))
        }
    }

    @IBOutlet weak var blueView: UIView! {
        didSet {
            blueView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveAndRotate)))
        }
    }

    @IBOutlet weak var greenView: UIView! {
        didSet {
            greenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveScaleAndChangeColor)))
        }
    }

    // MARK: - Private functions

    @objc private func makeRound() {
        let value = orangeView.bounds.width / 2
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
        animation.duration = 1.0
        animation.fromValue = orangeView.layer.cornerRadius
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        orangeView.layer.add(animation, forKey: nil)
        orangeView.layer.cornerRadius = value
    }

    @objc private func makeInvisible() {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        animation.duration = 1.0
        animation.fromValue = cyanView.layer.backgroundColor
        animation.toValue = nil
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        cyanView.layer.add(animation, forKey: nil)
        cyanView.layer.backgroundColor = nil
    }

    @objc private func moveAndRotate() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat(315.0 * .pi / 180.0)

        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = blueView.center
        moveAnimation.toValue = CGPoint(x: cyanView.center.x, y: blueView.layer.position.y)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotateAnimation, moveAnimation]
        groupAnimation.duration = 2
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        blueView.layer.add(groupAnimation, forKey: nil)
    }

    @objc private func moveScaleAndChangeColor() {
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = greenView.center
        moveAnimation.toValue = view.center

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 1.5

        let colorChangeAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorChangeAnimation.fromValue = UIColor.green.cgColor
        colorChangeAnimation.toValue = UIColor.magenta.cgColor


        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [moveAnimation, scaleAnimation, colorChangeAnimation]
        groupAnimation.duration = 1
        groupAnimation.repeatCount = 2
        groupAnimation.autoreverses = true
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        greenView.layer.add(groupAnimation, forKey: nil)
    }
}
