//
//  CalculatorViewController.swift
//  Course2Week3Task1
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var resultLabel: UILabel! {
        didSet {
            resultLabel.backgroundColor = UIColor(red: 238 / 255,
                                                  green: 238 / 255,
                                                  blue: 238 / 255,
                                                  alpha: 1)
            resultLabel.font = .systemFont(ofSize: 30)
            resultLabel.textAlignment = .right
            resultLabel.text = "1"
        }
    }

    @IBOutlet weak var firstOperandLabel: UILabel! {
        didSet {
            firstOperandLabel.font = .systemFont(ofSize: 17)
            firstOperandLabel.text = "First operand"
            firstOperandLabel.backgroundColor = .clear
            firstOperandLabel.textColor = .white
        }
    }

    @IBOutlet weak var firstOperandValueLabel: UILabel! {
        didSet {
            firstOperandValueLabel.font = .systemFont(ofSize: 17)
            firstOperandValueLabel.backgroundColor = .clear
            firstOperandValueLabel.textColor = .white
            firstOperandValueLabel.text = "1.0000"
        }
    }

    @IBOutlet weak var secondOperandLabel: UILabel! {
        didSet {
            secondOperandLabel.font = .systemFont(ofSize: 17)
            secondOperandLabel.text = "Second operand"
            secondOperandLabel.backgroundColor = .clear
            secondOperandLabel.textColor = .white
        }
    }

    @IBOutlet weak var secondOperandValueLabel: UILabel! {
        didSet {
            secondOperandValueLabel.font = .systemFont(ofSize: 17)
            secondOperandValueLabel.backgroundColor = .clear
            secondOperandValueLabel.textColor = .white
            secondOperandValueLabel.text = "1.0000"
        }
    }

    @IBOutlet weak var firstOperandValueStepper: UIStepper! {
        // Proper appearance of UIStepper can`t be set because of iOS13 updates
        didSet {
            firstOperandValueStepper.setDecrementImage(firstOperandValueStepper.decrementImage(for: .normal), for: .normal)
            firstOperandValueStepper.setIncrementImage(firstOperandValueStepper.incrementImage(for: .normal), for: .normal)
            firstOperandValueStepper.setBackgroundImage(firstOperandValueStepper.backgroundImage(for: .normal), for: .normal)
            firstOperandValueStepper.backgroundColor = UIColor(red: 45 / 255, green: 47 / 255, blue: 49 / 255, alpha: 1)
            firstOperandValueStepper.tintColor = UIColor(red: 236 / 255, green: 113 / 255, blue: 73 / 255, alpha: 1)
            firstOperandValueStepper.layer.cornerRadius = 5
            firstOperandValueStepper.layer.borderWidth = 1
            firstOperandValueStepper.layer.borderColor = UIColor(red: 236 / 255, green: 113 / 255, blue: 73 / 255, alpha: 1).cgColor

            firstOperandValueStepper.minimumValue = 1
            firstOperandValueStepper.maximumValue = 10
            firstOperandValueStepper.stepValue = 0.5
            firstOperandValueStepper.value = 1
        }
    }

    @IBOutlet weak var secondOperandValueSlider: UISlider! {
        didSet {
            secondOperandValueSlider.tintColor = UIColor(red: 236 / 255, green: 113 / 255, blue: 73 / 255, alpha: 1)
            secondOperandValueSlider.minimumValue = 1
            secondOperandValueSlider.maximumValue = 100
            secondOperandValueSlider.value = 1
        }
    }

    @IBOutlet weak var calculateButton: UIButton! {
        didSet {
            calculateButton.setTitle("Calculate", for: .normal)
            calculateButton.backgroundColor = UIColor(red: 236 / 255, green: 113 / 255, blue: 73 / 255, alpha: 1)
            calculateButton.setTitleColor(.white, for: .normal)
            calculateButton.titleLabel?.font = .systemFont(ofSize: 17)
        }
    }

    // MARK: - Private properties

    private var operandNumberFormatter: NumberFormatter!
    private var resultNumberFormatter: NumberFormatter!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNumberFomatters()

        setAppearence()
    }

    // MARK: - Private functions

    private func setNumberFomatters() {
        operandNumberFormatter = NumberFormatter()
        resultNumberFormatter = NumberFormatter()

        operandNumberFormatter.minimumFractionDigits = 4
        operandNumberFormatter.maximumFractionDigits = 4

        resultNumberFormatter.minimumFractionDigits = 0
        resultNumberFormatter.maximumFractionDigits = 4
    }

    private func setAppearence() {
        view.backgroundColor = UIColor(red: 45 / 255, green: 47 / 255, blue: 49 / 255, alpha: 1)

        resultLabel.frame = CGRect(x: 16,
                                   y: 32, width: view.bounds.width - 32, height: 60)

        firstOperandLabel.frame.origin = CGPoint(x: 16,
                                                 y: resultLabel.frame.origin.y + resultLabel.frame.height + 32)

        firstOperandValueStepper.frame.origin = CGPoint(x: view.bounds.width - firstOperandValueStepper.bounds.width - 16,
                                                        y: firstOperandLabel.frame.origin.y + firstOperandLabel.frame.height + 16)

        firstOperandValueLabel.center = firstOperandValueStepper.center
        firstOperandValueLabel.frame.origin = CGPoint(x: 16,
                                                      y: firstOperandValueLabel.frame.origin.y)

        secondOperandLabel.frame.origin = CGPoint(x: 16,
                                                  y: firstOperandValueStepper.frame.origin.y + firstOperandValueStepper.frame.height + 32)

        secondOperandValueSlider.frame.origin = CGPoint(x: view.bounds.width - secondOperandValueSlider.bounds.width - 16,
                                                        y: secondOperandLabel.frame.origin.y + secondOperandLabel.frame.height + 16)

        secondOperandValueLabel.center = secondOperandValueSlider.center
        secondOperandValueLabel.frame.origin = CGPoint(x: 16,
                                                       y: secondOperandValueLabel.frame.origin.y)

        calculateButton.frame = CGRect(x: 16, y: view.bounds.height - 16 - 60, width: view.bounds.width - 32, height: 60)
    }

    // MARK: - IBActios

    @IBAction func firstOperandStepperChangedValue(_ sender: UIStepper) {
        firstOperandValueLabel.text = operandNumberFormatter.string(from: NSNumber(value: sender.value))
    }

    @IBAction func secondOperandSliderChangedValue(_ sender: UISlider) {
        secondOperandValueLabel.text = operandNumberFormatter.string(from: NSNumber(value: sender.value))
    }

    @IBAction func calculate(_ sender: UIButton) {
        guard let firstOperandString = firstOperandValueLabel.text,
            let secondOperandString = secondOperandValueLabel.text,
            let firstOperand = Double(firstOperandString),
            let secondOperand = Double(secondOperandString) else {
                return
        }
        let result = firstOperand * secondOperand
        resultLabel.text = resultNumberFormatter.string(from: NSNumber(value: result))
    }

}

