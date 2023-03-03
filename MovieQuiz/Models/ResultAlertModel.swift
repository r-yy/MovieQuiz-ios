//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 02.02.2023.
//

import Foundation

struct ResultAlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completition: (() -> Void)?
    
}
