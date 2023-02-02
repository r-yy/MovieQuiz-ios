//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 02.02.2023.
//

import Foundation

struct AlertModel {
    let title: String
    var message: String
    let buttonText: String
    var completition: () -> () = {}
    
}
