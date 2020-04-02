//
//  UIKitDynamicController.swift
//  Course2Week4Task2
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class UIKitDynamicController: UIViewController {
    
    @IBOutlet weak var anchorView: UIView!
    @IBOutlet weak var animationView: UIView!

    private var dynamicAnimator: UIDynamicAnimator!
    private lazy var gravityBehavior = UIGravityBehavior(items: [animationView])
    private lazy var attachmentBehavior = UIAttachmentBehavior.init(item: animationView, attachedToAnchor: anchorView.center)
    private lazy var itemBehaviour = UIDynamicItemBehavior(items: [animationView])

    override func viewDidLoad() {
        super.viewDidLoad()

        anchorView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moveView)))

        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        itemBehaviour.elasticity = 0.5
        attachmentBehavior.attachmentRange = UIFloatRange(minimum: 100, maximum: 150)
        dynamicAnimator.addBehavior(itemBehaviour)
        dynamicAnimator.addBehavior(attachmentBehavior)
        dynamicAnimator.addBehavior(gravityBehavior)
    }

    @objc private func moveView(gesture: UIPanGestureRecognizer) {
        anchorView.center = gesture.location(in: view)
        attachmentBehavior.anchorPoint = anchorView.center
    }
}
