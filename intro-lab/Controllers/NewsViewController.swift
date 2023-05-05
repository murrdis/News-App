//
//  NewsViewController.swift
//  intro-lab
//
//  Created by Диас Мурзагалиев on 05.02.2023.
//

import Foundation
import UIKit

protocol NewsViewControllerDelegate {
    
}

class NewsViewController: UIViewController, UITableViewDelegate, mainViewControllerDelegate {
    // MARK: - Properties
        
    var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "NewsViewCell")
        return table
    }()
    
    var delegate: NewsViewControllerDelegate?
    
    let mainPageStore = MainPageStore()
    let mainViewController = MainViewController()
    
    var image: UIImage?
    
    var article: NewsArticle?
    
    // MARK: - ViewMethods

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        tableView.delegate = self
        tableView.dataSource = self
        mainViewController.delegate = self
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainViewController.tableView.reloadData()
    }
    
    func webKitLoad(_ url: String) {
        let webKitViewController = WebKitViewController(url: url)
        self.present(webKitViewController, animated: true)
        }
}

// MARK: - Extensions
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        
        cell.onNewsDidTap = { [weak self] url in
            self!.webKitLoad(url)
        }
        
        cell.titleLabel.text = article?.title
        cell.newsImage.image = image
        cell.source.text = article?.source
        if let author = article?.author {
            cell.author.text = "By: \(author)"
        }
        cell.date.text = article?.publishedAt
        cell.date.text?.removeLast(10)
        cell.newsText.text = article?.descriptionText
        cell.url = article?.url
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

