//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 04.03.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol {
    func showLoadingIndicator()
    func showNetworkError(message: String)
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: ResultAlertModel)
    func buttonsEnable(isEnabled: Bool)
    func highlightImageBorder(isCorrect: Bool)
    func disableImageBorder()
}
