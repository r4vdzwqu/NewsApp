//
//  NewsSourcesViewModel.swift
//

import Foundation

class NewsSourcesViewModel {
    var newsSources: [NewsSourcesModel]
    weak var delegate: RequestDelegate?
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    init(newsSources: [NewsSourcesModel]) {
        self.state = .idle
        self.newsSources = newsSources
    }
    
    func loadData() {
        self.state = .loading
        NewsService.getSources { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(sources):
                self.newsSources = sources
                self.state = .success
            case let .failure(error):
                self.newsSources = []
                self.state = .error(error)
            }
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return newsSources.count
    }
}
