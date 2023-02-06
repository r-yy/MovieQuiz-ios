import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    private var currentQuestionIndex = 0
    var correctAnswers = 0
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Bundle.main.bundlePath)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter()
        alertPresenter?.viewController = self
    }
    
    //MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
    }
    
    @IBAction private func noButtonPressed(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: false == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonPressed(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: true == currentQuestion.correctAnswer)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.text
        counterLabel.text = step.questionNumber
    }
   
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
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
            let quizResultModel = QuizResultViewModel(title: "Ваш результат: \(correctAnswers) из 10",
                                                      text: "Этот раунд окончен!",
                                                      buttonText: "Сыграть еще раз")
            
            var alertModel = convertToAlertModel(model: quizResultModel)
            
            alertModel.completition = { [weak self] in
                guard let self = self else { return }
                self.imageView.layer.borderWidth = 0
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.show(quiz: alertModel)
            
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
}
