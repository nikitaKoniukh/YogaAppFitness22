//
//  MyPlanViewController.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import UIKit

class MyPlanViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sessionsCollectionView: UICollectionView!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    
    var viewModel: MyPlanViewControllerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViewModel()
    }
    
    private func setupCollectionView() {
        sessionsCollectionView.register(SessionCollectionViewCell.self, forCellWithReuseIdentifier: "SessionCollectionViewCell")
        let nib = UINib(nibName: SessionCollectionViewCell.cellId, bundle: nil)
        sessionsCollectionView.register(nib, forCellWithReuseIdentifier: SessionCollectionViewCell.cellId)

        sessionsCollectionView.delegate = self
        sessionsCollectionView.dataSource = self
        sessionsCollectionView.isPagingEnabled = true
    }
    
    // TODO: move to app delegate
    private func setupViewModel() {
        viewModel = MyPlanViewControllerViewModel()
        viewModel?.delegate = self
        viewModel?.fetchSessions()
    }
    
    private func setupLabels() {
        chapterNameLabel.text = viewModel?.chapterText
        chapterNameLabel.text = viewModel?.chapterNameText
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        presentAlert()
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Title", message: "This is a message.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func scrollToNextSession() {
        if let currentSessionIndex = viewModel?.currentSessionIndex,
           let count = viewModel?.sessions.count {
            
            
            var indexPathToScroll: IndexPath
            if count > currentSessionIndex {
                indexPathToScroll = IndexPath(item: currentSessionIndex, section: 0)
            } else {
                indexPathToScroll = IndexPath(item: currentSessionIndex - 1, section: 0)
            }
            
            sessionsCollectionView.isPagingEnabled = false
            sessionsCollectionView.scrollToItem(at: indexPathToScroll, at: .centeredHorizontally, animated: true)
            sessionsCollectionView.isPagingEnabled = true
        }
    }
}

extension MyPlanViewController: MyPlanViewControllerViewModelDelegate {
    func fetechedSuccessfully() {
        setupLabels()
        sessionsCollectionView.reloadData()
        scrollToNextSession()
    }
    
    func fetechedWithError() {
        print("")
    }
}

extension MyPlanViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.sessions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SessionCollectionViewCell.cellId, for: indexPath) as? SessionCollectionViewCell

        let session = viewModel?.sessions[indexPath.item]
        let index = indexPath.item
        let cellViewModel = SessionCollectionViewCellViewModel(session: session, index: index)
        cell?.configure(viewModel: cellViewModel)
        return cell ?? UICollectionViewCell()
    }
}

extension MyPlanViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // change backgroundImage
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 100, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = collectionView.frame.width
        let margin = width * 0.3
        return UIEdgeInsets(top: 10, left: margin / 2, bottom: 10, right: margin / 2)
    }
}
