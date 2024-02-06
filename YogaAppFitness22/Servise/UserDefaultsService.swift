//
//  UserDefaultsService.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()
    private init(){}
    
    func saveCurrentSession(_ index: Int) {
        let defaults = UserDefaults.standard
        defaults.set(index, forKey: "CurrentSession")
    }
    
    func getCurrentSessionIndex() -> Int {
        let defaults = UserDefaults.standard
        let index = defaults.integer(forKey: "CurrentSession")
        return index
    }
}
