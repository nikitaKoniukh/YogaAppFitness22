//
//  MyPlanViewControllerViewMode.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import Foundation

final class MyPlanViewControllerViewModel {
    
    var sessions: [Session] = []
    
    init() {
        let fileName = "sessions.json"
        APIService.shared.load(fileName, completion: { [weak self] result in
            switch result {
            case .success(let sessions) :
                self?.sessions = sessions
            case .failure(_):
                // fix error
                break
            }
        })
    }
    

}
