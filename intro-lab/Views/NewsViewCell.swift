//
//  NewsViewCell.swift
//  intro-lab
//
//  Created by Диас Мурзагалиев on 05.02.2023.
//

import UIKit

class NewsViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var webViewButton: UIButton!
    
    var url: String? = nil
    var onNewsDidTap: ((_ url: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        newsImage.layer.cornerRadius = 15
    }
    
    @IBAction func webViewButtonPressed(_ sender: UIButton) {
        if let url = self.url {
            self.onNewsDidTap!(url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
