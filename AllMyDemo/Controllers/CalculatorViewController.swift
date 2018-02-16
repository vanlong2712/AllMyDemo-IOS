//
//  CalculatorViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/10/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    var temp: String = ""
    var formula: Int = 0
    var dot: Bool = false
    var needCalc: Bool = false
    var changeLabelAfterChoosingOperation: Bool = false
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0...9:
            if let numberText = label.text {
                if numberText == "0" || (12...16 ~= formula && changeLabelAfterChoosingOperation) {
                    label.text = String(sender.tag)
                    changeLabelAfterChoosingOperation = false
                } else {
                    label.text = numberText + String(sender.tag)
                }
                
                if 12...16 ~= formula {
                    needCalc = true
                }
            }
            break
        case 10:
            label.text = label.text! + "."
            dot = true
        case 11:
            operation()
            formula = 0
            changeLabelAfterChoosingOperation = false
        case 12...15:
            operation()
            temp = label.text!
            formula = sender.tag
            changeLabelAfterChoosingOperation = true
            break
        case 16:
            label.text = String(Double(label.text!)! * 0.01)
            dot = true
            break
        case 17:
            if let text = label.text {
                let number = Double(text)! * -1
                let isInteger = floor(number) == number
                if isInteger {
                    dot = false
                    label.text = String(format: "%.0f", number)
                }
            }
            break
        default:
            formula = 0
            temp = ""
            dot = false
            needCalc = false
            label.text = "0"
        }
    }
    
    func operation() {
        if needCalc {
            if dot {
                let numberOfTemp = Double(temp)
                let numberOfLabel = Double(label.text!)
                switch(formula) {
                case 12:
                    label.text = String(numberOfTemp! + numberOfLabel!)
                case 13:
                    label.text = String(numberOfTemp! - numberOfLabel!)
                case 14:
                    label.text = String(numberOfTemp! * numberOfLabel!)
                case 15:
                    label.text = String(numberOfTemp! / numberOfLabel!)
                default:
                    label.text = String((Double(label.text!)! * 0.01))
                }
                let isInteger = floor(Double(label.text!)!) == Double(label.text!)!
                if isInteger {
                    dot = false
                    label.text = String(format: "%.0f", Double(label.text!)!)
                }
            } else {
                let numberOfTemp = Int(temp)
                let numberOfLabel = Int(label.text!)
                switch(formula) {
                case 12:
                    label.text = String(numberOfTemp! + numberOfLabel!)
                case 13:
                    label.text = String(numberOfTemp! - numberOfLabel!)
                case 14:
                    label.text = String(numberOfTemp! * numberOfLabel!)
                case 15:
                    dot = true
                    label.text = String(Double(numberOfTemp!) / Double(numberOfLabel!))
                    let isInteger = floor(Double(label.text!)!) == Double(label.text!)!
                    if isInteger {
                        dot = false
                        label.text = String(format: "%.0f", Double(label.text!)!)
                    }
                default:
                    return
                }
            }
            needCalc = false
        }
    }
}
