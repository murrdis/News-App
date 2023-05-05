//
//  MainPageStore.swift
//  intro-lab
//
//  Created by Диас Мурзагалиев on 04.02.2023.
//

import Foundation
import UIKit

protocol MainStoreDelegate {
    var articles : [Article] { get set }
    var imageForUrl : [String : UIImage] { get set }
    var tableView: UITableView { get }
}

class MainPageStore {
    // MARK: - Properties
    var delegate: MainStoreDelegate?
    let newsManager = NewsManager()
    
    // MARK: - Methods
    func getMainData() {
        newsManager.getNews { [weak self] result in
            guard let articles = try? result.get() else {
                return
            }
            self?.delegate?.articles = articles
        }
    }
    
    func getImage(for imageUrl: String) {
        newsManager.getImage(imageUrl) { [weak self] data in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            self?.delegate?.imageForUrl[imageUrl] = image
            // make some kind of reload
            // self?.delegate?.tableView.reloadData()
        }
    }
}
