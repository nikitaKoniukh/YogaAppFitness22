//
//  SessionCollectionViewCellViewModel.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import Foundation

final class SessionCollectionViewCellViewModel {
    let session: Session?
    var index: Int?
    
    var difficultyImageName: String {
        switch session?.difficultyType {
        case .easy:
            return "intensity_1_dark"
        case .medium:
            return "intensity_2_dark"
        case .hard:
            return "intensity_3_dark"
        case .none:
            return "intensity_1_dark" // ask error handling
        }
    }
    
    var lengthText: String {
        if let length = session?.length {
            return "\(length) min"
        }
        
        return "0 min" // ask error handling
    }
    
    var sessionNumberText: String {
        if let index {
            return "Session \(index + 1)"
        }
        
        return ""
    }
    
    var quoteText: String {
        if let quote = session?.quote {
            return "\"" + quote + "\""
        }
        
        return ""
    }
    
    init(session: Session?, index: Int?) {
        self.session = session
        self.index = index
    }
    
    func saveCurrentSession() {
        guard let index else {
            return
        }
        
        UserDefaultsService.shared.saveCurrentSession(index + 1)
    }
    
}
