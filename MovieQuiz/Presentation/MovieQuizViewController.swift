import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    private var presenter: MovieQuizPresenter!
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        showLoadingIndicator()
        
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    func showLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        showLoadingIndicator()
        let alert = ResultAlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Повторите еще раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.loadDataWhenNetworkDisabled()
        }
        show(quiz: alert)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        buttonsEnable(isEnabled: true)
        activityIndicator.stopAnimating()
        textLabel.text = step.text
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: ResultAlertModel) {

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
        present(alert, animated: true, completion: nil)
    }
    
    func buttonsEnable(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        buttonsEnable(isEnabled: false)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    func disableImageBorder() {
        imageView.layer.borderWidth = 0
    }

    @IBAction private func noButtonPressed(_ sender: UIButton) {
        presenter.noButtonPressed()
    }
    
    @IBAction private func yesButtonPressed(_ sender: UIButton) {
        presenter.yesButtonPressed()
    }
}
