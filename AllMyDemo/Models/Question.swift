//
//  Question.swift
//  AllMyDemo
//
//  Created by Long on 2/11/18.
//  Copyright © 2018 Long Dang. All rights reserved.
//

import Foundation

class Question {
    let questionText: String
    let answer: Bool
    
    init(text: String, correctAnswer: Bool) {
        questionText = text
        answer = correctAnswer
    }
}
