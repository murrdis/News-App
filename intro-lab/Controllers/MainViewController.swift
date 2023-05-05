//
//  ViewController.swift
//  intro-lab
//
//  Created by Диас Мурзагалиев on 03.02.2023.
//

import UIKit
import CoreData
protocol mainViewControllerDelegate {
    
}

class MainViewController: UIViewController, UITableViewDelegate, MainStoreDelegate {
    // MARK: - Properties
    var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(UINib(nibName: "MainViewCell", bundle: nil), forCellReuseIdentifier: "MainViewCell")
        return table
    }()
    
    var delegate: mainViewControllerDelegate?
    
    let mainPageStore = MainPageStore()
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    var imageForUrl = [String : UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var articles: [Article] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.saveNewsArticles()
            }
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var newsArticles: [NewsArticle] = []
    
    var views = [String : Int]()
    
    // MARK: - ViewMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        tableView.refreshControl = myRefreshControl
        tableView.delegate = self
        tableView.dataSource = self
        
        loadNewsArticles()
        
        mainPageStore.delegate = self
        DispatchQueue.main.async {
            self.mainPageStore.getMainData()
            self.saveNewsArticles()
        }
    

        
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Methods
    @objc private func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
        saveNewsArticles()
        sender.endRefreshing()
    }
    
    func saveNewsArticles() {

        if articles.count != 0 {
            newsArticles = []
            for i in 0...articles.count-1 {
                var newsArticle: NewsArticle = NewsArticle(context: context)
                newsArticle.title = articles[i].title
                newsArticle.source = articles[i].source.name
                newsArticle.author = articles[i].author
                newsArticle.url = articles[i].url
                newsArticle.urlToImage = articles[i].urlToImage
                newsArticle.descriptionText = articles[i].description
                newsArticle.publishedAt = articles[i].publishedAt
                newsArticles.append(newsArticle)
                do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
            }
        }
    }
    
    func loadNewsArticles() {
        let request : NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        do {
            newsArticles = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}



// MARK: - Extensions
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
        cell.titleLabel.text = newsArticles[indexPath.row].title
        if views[newsArticles[indexPath.row].title ?? ""] != nil {
            cell.numberOfViews = views[newsArticles[indexPath.row].title!]!
        } else {
            cell.numberOfViews = 0
        }
        if let image = imageForUrl[newsArticles[indexPath.row].urlToImage ?? ""] {
            cell.newsImage.image = image
        } else {
            cell.newsImage.image = nil
            mainPageStore.getImage(for: newsArticles[indexPath.row].urlToImage ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! MainViewCell
        if views[newsArticles[indexPath.row].title!] != nil {
            views[newsArticles[indexPath.row].title!]! += 1
        } else {
            views[newsArticles[indexPath.row].title!] = 1
        }
        
        let newsViewController = NewsViewController()
        newsViewController.image = imageForUrl[newsArticles[indexPath.row].urlToImage ?? ""]
        newsViewController.article = newsArticles[indexPath.row]
        navigationController?.pushViewController(newsViewController, animated: true)
    }
}



extension MainViewController: UITableViewDataSourcePrefetching{
    // This is called when the rows are near to the visible area
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]){
        for indexPath in indexPaths {
            if let url = articles[indexPath.row].urlToImage, imageForUrl[url] == nil {
                mainPageStore.getImage(for: url)
            }
        }
    }
    
    // This is called when the rows move further away from visible area, eg: user scroll in an opposite direction
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]){
        // make nsOperationCancellation Methods
    }
}
