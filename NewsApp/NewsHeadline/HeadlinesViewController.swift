//
//  HeadlinesViewController.swift
//

import UIKit
import SafariServices

class HeadlinesViewController: AppController {
    var currentSource = ""
    var viewModel: HeadlinesViewModel
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: HeadlinesViewModel) {
        self.viewModel = viewModel
        super.init()
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.view.addSubview(tableView)
        self.setupTableView()
        currentSource = NewsSourceManager.getNewsSource()
        self.viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshIfSourceChanged()
    }
    
    func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HeadlinesCell.self, forCellReuseIdentifier: HeadlinesCell.reuseIdentifier)
    }
    
    func fetchNews() {
        NewsService.getNews { response in
            switch response {
            case let .success(news):
                print(news)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        
        NewsService.getSources { response in
            switch response {
            case let .success(sources):
                print(sources)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func openDetailView(_ headline: HeadlinesModel) {
        guard let url = URL(string: headline.newsLink) else {
            print("News Link missing :(")
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension HeadlinesViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

extension HeadlinesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeadlinesCell.reuseIdentifier, for: indexPath) as? HeadlinesCell else { fatalError("Unexpected Table View Cell") }
        
        let headline = viewModel.headlines[indexPath.row]
        cell.configure(title: headline.title, imageLink: headline.imageLink)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let headline = viewModel.headlines[indexPath.row]
        openDetailView(headline)
    }
}

extension HeadlinesViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                self.startLoading()
            case .success:
                self.tableView.reloadData()
                self.stopLoading()
                if viewModel.headlines.isEmpty {
                    self.present(title: "No News!", message: "Please change the news source and try again", customAction:nil)
                }
            case .error(let error):
                self.stopLoading()
                self.present(error: error, customAction: UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.viewModel.loadData()
                }))
            }
        }
    }
}

extension HeadlinesViewController {
    func refreshIfSourceChanged() {
        if NewsSourceManager.getNewsSource().isEqual(self.currentSource) {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel.loadData()
        }
    }
}
