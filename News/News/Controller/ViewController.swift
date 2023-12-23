//
//  ViewController.swift
//  News
//
//  Created by Ziya Zaidov on 11.12.2023.
//

import UIKit
import SafariServices


class ViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
   private var viewModel = [NewsTableViewCellViewModel]()
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        navigationController?.navigationBar.prefersLargeTitles = true

        title = "Hot News"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchTopNews()
        createSearchBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    private func fetchTopNews() {
        ApiCaller.shared.getTopStories {[weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModel = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "",
                                               mageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell

        cell.configure(with: viewModel[indexPath.row] )
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else {return}
            let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {return}
        ApiCaller.shared.searchURL(wirh: text) {[weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModel = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "",
                                               mageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
        print(text)
    }
}
