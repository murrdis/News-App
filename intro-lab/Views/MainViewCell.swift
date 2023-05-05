//
//  NewsCell.swift
//  intro-lab
//
//  Created by Диас Мурзагалиев on 04.02.2023.
//

import UIKit

class MainViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfViewsLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    var numberOfViews = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImage.layer.cornerRadius = 15
        numberOfViewsLabel.text = "\(numberOfViews)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        numberOfViewsLabel.text = "\(numberOfViews)"
        // Configure the view for the selected state
    }
    
}
