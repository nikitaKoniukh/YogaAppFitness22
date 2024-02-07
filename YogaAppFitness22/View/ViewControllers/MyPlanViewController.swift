//
//  MyPlanViewController.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import UIKit

class MyPlanViewController: UIViewController {
    
    private enum AlertType {
        case oneButton
        case twoButtons
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sessionsCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    
    var viewModel: MyPlanViewControllerViewModel?
    private var indexOfCellBeforeDragging = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayoutItemSize()
    }
    
    private func calculateSectionInset() -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)
        
        let buttonWidth: CGFloat = 50
        
        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return inset
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    private var indexOfMajorCell: Int {
        guard let sessions = viewModel?.sessions else {
            return 0
        }
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(sessions.count - 1, index))
        return safeIndex
    }
    
    private var indexOfMajorCellAfterScroll: Int? {
        let visibleRect = CGRect(origin: sessionsCollectionView.contentOffset, size: sessionsCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = sessionsCollectionView.indexPathForItem(at: visiblePoint) else {
            return 0
        }
        
        return visibleIndexPath.item
    }
    
    private func setupCollectionView() {
        sessionsCollectionView.register(SessionCollectionViewCell.self, forCellWithReuseIdentifier: "SessionCollectionViewCell")
        let nib = UINib(nibName: SessionCollectionViewCell.cellId, bundle: nil)
        sessionsCollectionView.register(nib, forCellWithReuseIdentifier: SessionCollectionViewCell.cellId)
        collectionViewLayout.minimumLineSpacing = 0
        sessionsCollectionView.isPrefetchingEnabled = false
        sessionsCollectionView.delegate = self
        sessionsCollectionView.dataSource = self
    }
    
    // TODO: move to app delegate
    private func setupViewModel() {
        viewModel = MyPlanViewControllerViewModel()
        viewModel?.delegate = self
        viewModel?.fetchSessions()
    }
    
    private func setupLabels() {
        chapterNumberLabel.text = viewModel?.chapterText
        chapterNameLabel.text = viewModel?.chapterNameText
        backgroundImageView.image = viewModel?.backroundImageName
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        presentAlert(title: "Title", message: "This is a message.", alertType: .twoButtons)
    }
    
    private func presentAlert(title: String, message: String, alertType: AlertType) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch alertType {
        case .oneButton:
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        case .twoButtons:
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func scrollToNextSession() {
        if let currentSessionIndex = viewModel?.currentSessionIndex {
            let indexPathToScroll = IndexPath(item: currentSessionIndex, section: 0)
            DispatchQueue.main.async { [weak self] in
                self?.sessionsCollectionView.scrollToItem(at: indexPathToScroll, at: .centeredHorizontally, animated: true)
            }
        }
    }
}

extension MyPlanViewController: MyPlanViewControllerViewModelDelegate {
    func changeBackgroundUI() {
        setupLabels()
    }
    
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
        cell?.delegate = self
        return cell ?? UICollectionViewCell()
    }
}

extension MyPlanViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let sessions = viewModel?.sessions else {
            return
        }
        
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell
        
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < sessions.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
            // TODO: Change chapter label amd backgroun image
            viewModel?.indexOfMajorCell = indexOfMajorCellAfterScroll
            print("NIKITOS visibleVideoCell \(indexOfMajorCellAfterScroll)")
            
        } else {
            // TODO: Change chapter label amd backgroun image
            viewModel?.indexOfMajorCell = indexOfMajorCell
            print("NIKITOS \(indexOfMajorCell)")
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
   
}


extension MyPlanViewController: SessionCollectionViewCellDelegate {
    func startButtonPressed(message: String) {
        presentAlert(title: "Title", message: message, alertType: .oneButton)
    }
}
