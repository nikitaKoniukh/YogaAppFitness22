//
//  SessionCollectionViewCell.swift
//  YogaAppFitness22
//
//  Created by Nikita Koniukh on 06/02/2024.
//

import UIKit

class SessionCollectionViewCell: UICollectionViewCell {

    static let cellId = "SessionCollectionViewCell"
     
    @IBOutlet weak var sessionNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var difficultyImageView: UIImageView!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    
    var viewModel: SessionCollectionViewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    
    func configure(viewModel: SessionCollectionViewCellViewModel?) {
        self.viewModel = viewModel
        setOutlets()
        
    }
    
    private func setOutlets() {
        guard let viewModel else {
            return
        }
        
        sessionNameLabel.text = viewModel.sessionNumberText
        difficultyLabel.text = viewModel.session?.difficulty
        difficultyImageView.image = UIImage(named: viewModel.difficultyImageName)
        lengthLabel.text = viewModel.lengthText
        quoteLabel.text = viewModel.quoteText
        quoteAuthorLabel.text = viewModel.session?.quoteAuthor
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        viewModel?.saveCurrentSession()
    }
}
