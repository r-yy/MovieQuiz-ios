//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 02.03.2023.
//

import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex = 0
    
    let questionsAmount: Int = 10
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
}
