//
//  NewsSourcesViewController.swift
//

import UIKit

class NewsSourcesViewController: AppController {
    var viewModel: NewsSourcesViewModel
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: NewsSourcesViewModel) {
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
        self.viewModel.loadData()
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
        tableView.register(NewsSourcesCell.self, forCellReuseIdentifier: NewsSourcesCell.reuseIdentifier)
    }
    
    func setSourceForNews(_ newsSource: String) {
        NewsSourceManager.setNewsSource(newsSource)
    }
}

extension NewsSourcesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsSourcesCell.reuseIdentifier, for: indexPath) as? NewsSourcesCell else { fatalError("Unexpected Table View Cell") }
        
        let newsSource = viewModel.newsSources[indexPath.row]
        
        cell.configure(title: newsSource.name, isSelected: isThisSelected(newsSource.id))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsSource = viewModel.newsSources[indexPath.row]
        setSourceForNews(newsSource.id)
        self.tableView.reloadData()
    }
    
    func isThisSelected(_ source: String) -> Bool {
        return NewsSourceManager.getNewsSource().isEqual(source)
    }
}

extension NewsSourcesViewController: RequestDelegate {
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




