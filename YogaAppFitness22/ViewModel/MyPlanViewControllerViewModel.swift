//
//  MyPlanViewControllerViewMode.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import Foundation

protocol MyPlanViewControllerViewModelDelegate: AnyObject {
    func fetechedSuccessfully()
    func fetechedWithError()
}

final class MyPlanViewControllerViewModel {
    weak var delegate: MyPlanViewControllerViewModelDelegate?
    var sessions: [Session] = []
    
    var currentSession: Session? {
        let index = UserDefaultsService.shared.getCurrentSessionIndex()
        if !sessions.isEmpty, sessions.count > index {
            return sessions[index]
        }
        
        return nil
    }
    
    var currentSessionIndex: Int {
        return UserDefaultsService.shared.getCurrentSessionIndex() + 1
    }
    
    var chapterText: String? {
        if let chapter = currentSession?.chapter {
            return "CHAPTER \(chapter)"
        }
        
        return nil
    }
    
    var chapterNameText: String? {
        return currentSession?.chapterName
    }
    
    func fetchSessions() {
        let fileName = "sessions.json"
        APIService.shared.load(fileName, completion: { [weak self] result in
            switch result {
            case .success(let sessions) :
                self?.sessions = sessions
                self?.delegate?.fetechedSuccessfully()
            case .failure(_):
                // TODO: Need to handle errors
                self?.delegate?.fetechedWithError()
            }
        })
    }
}
