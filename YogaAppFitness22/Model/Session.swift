//
//  Session.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import Foundation

struct Session: Codable {
    var length: Int
    var quoteAuthor: String
    var quote: String
    var chapterName: String
    var chapter: Int
    var difficulty: String
    
    
    var difficultyType: DifficultyType {
        switch difficulty {
        case "Easy":
            return .easy
        case "Medium":
            return .medium
        default:
            return .hard
        }
    }
    
    enum DifficultyType: String {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}
