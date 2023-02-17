import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    private var currentQuestionIndex = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var resultAlertPresenter: AlertProtocol?
    private var statisticService: StatisticService?
    private var feedbackGenerator: UINotificationFeedbackGenerator?
    
    var correctAnswers: Int = 0
    let questionsAmount: Int = 10
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        
        resultAlertPresenter = ResultAlertPresenter()
        resultAlertPresenter?.viewController = self
        
        statisticService = StatisticServiceImplementation()
        
        feedbackGenerator = UINotificationFeedbackGenerator()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.text
        counterLabel.text = step.questionNumber
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        buttonsEnable(isEnabled: false)
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        buttonsEnable(isEnabled: true)
        
        if currentQuestionIndex == questionsAmount - 1 {
            
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
                self.imageView.layer.borderWidth = 0
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            resultAlertPresenter?.show(quiz: alertModel)
            
        } else {
            currentQuestionIndex += 1
            self.imageView.layer.borderWidth = 0
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func buttonsEnable(isEnabled: Bool) {
        if isEnabled {
            noButton.isEnabled = true
            yesButton.isEnabled = true
        } else {
            noButton.isEnabled = false
            yesButton.isEnabled = false
        }
    }
    
    private func convertToAlertModel(model: QuizResultViewModel) -> AlertModel {
        return AlertModel(
            title: model.title,
            message: model.text,
            buttonText: model.buttonText
        )
    }
    
    private func showLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        self.show(quiz: viewModel)
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
        activityIndicator.stopAnimating()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func showNetworkError(message: String) {
        showLoadingIndicator()
        let alert = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Повторите еще раз") { [weak self] in
            guard let self = self else { return }
            self.questionFactory?.loadData()
        }
        resultAlertPresenter?.show(quiz: alert)
    }
    
    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        feedbackGenerator?.prepare()
    }
    
    @IBAction private func noButtonPressed(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
        
        if currentQuestion.correctAnswer {
            feedbackGenerator?.notificationOccurred(.error)
        } else {
            feedbackGenerator?.notificationOccurred(.success)
        }
    }
    
    @IBAction private func yesButtonPressed(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
        
        if currentQuestion.correctAnswer {
            feedbackGenerator?.notificationOccurred(.success)
        } else {
            feedbackGenerator?.notificationOccurred(.error)
        }
    }
}
