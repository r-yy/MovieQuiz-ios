//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 02.02.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertProtocol {

    var viewModel: AlertModel?
    weak var viewController: UIViewController?
        
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
        viewController?.present(alert, animated: true, completion: nil)
    }
}
