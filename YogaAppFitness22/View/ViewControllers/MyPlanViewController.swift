//
//  MyPlanViewController.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import UIKit

class MyPlanViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    var viewModel: MyPlanViewControllerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
    }
    
    // TODO: move to app delegate
    func setupViewModel() {
        viewModel = MyPlanViewControllerViewModel()
        viewModel?.delegate = self
        viewModel?.fetchSessions()
    }


}

extension MyPlanViewController: MyPlanViewControllerViewModelDelegate {
    func fetechedSuccessfully() {
        print("")
    }
    
    func fetechedWithError() {
        print("")
    }
    
    
}
