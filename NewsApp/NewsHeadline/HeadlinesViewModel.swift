//
//  HeadlinesViewModel.swift
//

import Foundation

class HeadlinesViewModel {
    var headlines: [HeadlinesModel]
    weak var delegate: RequestDelegate?

    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    init(headlines: [HeadlinesModel]) {
        self.state = .idle
        self.headlines = headlines
    }
    
    func loadData() {
        self.state = .loading
        NewsService.getNews { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case let .success(news):
                weakSelf.headlines = news
                weakSelf.state = .success
            case let .failure(error):
                weakSelf.headlines = []
                weakSelf.state = .error(error)
            }
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return headlines.count
    }
}
