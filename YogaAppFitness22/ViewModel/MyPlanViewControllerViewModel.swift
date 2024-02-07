//
//  MyPlanViewControllerViewMode.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import UIKit

protocol MyPlanViewControllerViewModelDelegate: AnyObject {
    func fetechedSuccessfully()
    func fetechedWithError()
    func changeBackgroundUI()
}

final class MyPlanViewControllerViewModel {
    weak var delegate: MyPlanViewControllerViewModelDelegate?
    private(set) var sessions: [Session] = []
    private(set) var chapterText = ""
    private(set) var chapterNameText = ""
    private(set) var backroundImageName: UIImage?
    private(set) var currentSession: Session?
    
    var currentSessionIndex: Int {
        let savedIndex = UserDefaultsService.shared.getCurrentSessionIndex()
        if sessions.count > savedIndex {
            return savedIndex
        } else {
            return savedIndex - 1
        }
    }

    var indexOfMajorCell: Int? {
        didSet {
            if let indexOfMajorCell {
                let chapter = sessions[indexOfMajorCell].chapter
                let chapterName = sessions[indexOfMajorCell].chapterName
                chapterText = "CHAPTER \(chapter)"
                chapterNameText = chapterName
                setCurrenBackgrounImage()
                
                
                delegate?.changeBackgroundUI()
            }
        }
    }
    
    private func setCurrenBackgrounImage() {
        if !sessions.isEmpty,
           let indexOfMajorCell {
            switch sessions[indexOfMajorCell].chapter {
            case 1:
                backroundImageName = UIImage(named: "chapter1_bg")
            case 2:
                backroundImageName = UIImage(named: "chapter2_bg")
            case 3:
                backroundImageName = UIImage(named: "chapter3_bg")
            default:
                backroundImageName = UIImage(named: "chapter3_bg")
            }
        }
    }
    
    func fetchSessions() {
        let fileName = "sessions.json"
        APIService.shared.load(fileName, completion: { [weak self] result in
            switch result {
            case .success(let sessions) :
                self?.sessions = sessions
                self?.getCurrentSession()
                self?.delegate?.fetechedSuccessfully()
            case .failure(_):
                // TODO: Need to handle errors
                self?.delegate?.fetechedWithError()
            }
        })
    }
    
    private func getCurrentSession() {
        let index = UserDefaultsService.shared.getCurrentSessionIndex()
        if !sessions.isEmpty, sessions.count > index {
            currentSession = sessions[index]
            indexOfMajorCell = index
        }
    }
}
