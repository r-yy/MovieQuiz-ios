//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 02.03.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    private var statisticService: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        feedbackGenerator = UINotificationFeedbackGenerator()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        self.viewController?.show(quiz: viewModel)
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
        viewController?.disableImageBorder()
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
        
        proceedWithAnswer(isCorrect: givenAnswer)
        
        if givenAnswer {
            feedbackGenerator?.notificationOccurred(.success)
        } else {
            feedbackGenerator?.notificationOccurred(.error)
        }
    }
    
    func proceedToNextQuestionOrResults() {
        
        if isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard let gamesCount = statisticService?.gamesCount,
                  let correct = statisticService?.bestGame.correct,
                  let total = statisticService?.bestGame.total,
                  let bestGameDate = statisticService?.bestGame.date.dateTimeString,
                  let totalAccuracy = statisticService?.totalAccuracy else {
                return
            }
            
            let record = "\(correct)/\(total)"
            let title = "Этот раунд окончен!"
            let message =
                "Ваш результат: \(correctAnswers)/\(questionsAmount)" +
                "\n Количество сыгранных квизов: \(gamesCount)" +
                "\n Рекорд: \(record) (\(bestGameDate))" +
                "\n Средняя точность: \(String(format: "%.2f", totalAccuracy))%"
            let buttonText = "Сыграть еще раз"
            
            var resultAlertModel = ResultAlertModel(
                title: title,
                message: message,
                buttonText: buttonText)
            
            resultAlertModel.completition = { [weak self] in
                guard let self = self else { return }
                self.restartGame()
            }
            viewController?.show(quiz: resultAlertModel)
            
        } else {
            viewController?.disableImageBorder()
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect { correctAnswers += 1 }
        
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    func loadDataWhenNetworkDisabled() {
        questionFactory?.loadData()
    }
}
