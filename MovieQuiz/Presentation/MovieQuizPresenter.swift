//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 02.03.2023.
//

import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex = 0
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    private var statisticService: StatisticService?
    
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    var correctAnswers = 0
    var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonPressed() {
        didAnswer(isYes: true)
    }
    
    func noButtonPressed() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = isYes == currentQuestion.correctAnswer
        
        viewController?.showAnswerResult(isCorrect: givenAnswer)
        
        feedbackGenerator = UINotificationFeedbackGenerator()
        if givenAnswer {
            feedbackGenerator?.notificationOccurred(.success)
            correctAnswers += 1
        } else {
            feedbackGenerator?.notificationOccurred(.error)
        }
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        self.viewController?.show(quiz: viewModel)
    }
    
    func showNextQuestionOrResults() {
        viewController?.buttonsEnable(isEnabled: true)
        
        if isLastQuestion() {
            
            statisticService = StatisticServiceImplementation()
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            
            guard let gamesCount = statisticService?.gamesCount,
                  let correct = statisticService?.bestGame.correct,
                  let total = statisticService?.bestGame.total,
                  let bestGameDate = statisticService?.bestGame.date.dateTimeString,
                  let totalAccuracy = statisticService?.totalAccuracy else {
                return
            }
            let record = "\(correct)/\(total)"
            var resultAlertModel = ResultAlertModel(
                title: "Этот раунд окончен!",
                message: "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыгранных квизов: \(gamesCount)\n Рекорд: \(record) (\(bestGameDate))\n Средняя точность: \(String(format: "%.2f", totalAccuracy))%",
                buttonText: "Сыграть еще раз")
            
            resultAlertModel.completition = { [weak self] in
                guard let self = self else { return }
                self.restartGame()
                self.questionFactory?.requestNextQuestion()
            }
            viewController?.show(quiz: resultAlertModel)
            
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
