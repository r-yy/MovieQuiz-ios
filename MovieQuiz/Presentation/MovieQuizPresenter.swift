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
    
    private func convertToAlertModel(model: QuizResultViewModel) -> AlertModel {
        return AlertModel(
            title: model.title,
            message: model.text,
            buttonText: model.buttonText
        )
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
            let quizResultModel = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыгранных квизов: \(gamesCount)\n Рекорд: \(record) (\(bestGameDate))\n Средняя точность: \(String(format: "%.2f", totalAccuracy))%",
                buttonText: "Сыграть еще раз")
            
            var alertModel = convertToAlertModel(model: quizResultModel)
            
            alertModel.completition = { [weak self] in
                guard let self = self else { return }
                self.restartGame()
                self.questionFactory?.requestNextQuestion()
            }
            show(quiz: alertModel)
            
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func show(quiz result: AlertModel) {

        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: result.buttonText, style: .default, handler: { _ in
                result.completition?()
        })

        alert.addAction(action)
        alert.view.accessibilityIdentifier = "ResultAlert"
        viewController?.present(alert, animated: true, completion: nil)
    }
}
