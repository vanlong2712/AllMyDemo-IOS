//
//  QuestionViewController.swift
//  AllMyDemo
//
//  Created by Long on 2/11/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    let listQuestion = QuestionBank().list
    var questionNumber: Int = 0
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restartButton.isHidden = true
        updateUI()
    }
    
    func checkAnswer(pickedAnswer: Bool) {
        if pickedAnswer == listQuestion[questionNumber].answer {
            SVProgressHUD.showSuccess(withStatus: "Correct!")
            score += 1
        } else {
            SVProgressHUD.showError(withStatus: "Wrong!")
        }
        questionNumber += 1
        if questionNumber == listQuestion.count {
            trueButton.isHidden = true
            falseButton.isHidden = true
            restartButton.isHidden = false
            questionLabel.text = "Awesome!!! You've finished all the questions"
        }
        updateUI()
    }
    
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        startOver()
    }
    
    @IBAction func answerPressed(_ sender: UIButton) {
        var answer: Bool = false
        if sender.tag == 1 {
            answer = true
        }
        checkAnswer(pickedAnswer: answer)
    }
    
    func updateUI() {
        if questionNumber < listQuestion.count {
            questionLabel.text = listQuestion[questionNumber].questionText
            progressLabel.text = "\(questionNumber + 1)/\(listQuestion.count)"
            scoreLabel.text = "Score: \(score)"
        }
        progressBarView.frame.size.width = (view.frame.size.width / CGFloat(listQuestion.count)) * CGFloat(questionNumber)
    }
    
    func startOver() {
        questionNumber = 0
        score = 0
        restartButton.isHidden = true
        trueButton.isHidden = false
        falseButton.isHidden = false
        updateUI()
    }
    
}
