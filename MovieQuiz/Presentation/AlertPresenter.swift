//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 02.02.2023.
//

import Foundation
import UIKit

class AlertPresenter: UIViewController {
    //var correctAnswers = MovieQuizViewController().correctAnswers
    var questionFactory: QuestionFactoryProtocol?
    
    var viewModel: AlertModel = AlertModel(title: "Ваш результат: 1 из 10",
                                           message: "Этот раунд окончен!",
                                           buttonText: "Сыграть еще раз")
        
        

    func show(quiz result: AlertModel) {

        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: result.buttonText, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }

            self.questionFactory?.requestNextQuestion()
        })

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
}
