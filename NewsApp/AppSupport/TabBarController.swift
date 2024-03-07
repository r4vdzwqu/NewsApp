//
//  TabBarController.swift
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
    }
    
    private func setupTabs() {
        
        self.tabBar.barTintColor = .secondarySystemBackground
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .systemGray
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        let savedNewsVC = self.createNavigationController(with: "Saved", and: UIImage(systemName: "bookmark.square"), viewController: SavedArticlesViewController())
        
        self.setViewControllers(
            [
                self.getHeadlinesViewController(),
                self.getSourcesViewController(),
                savedNewsVC
            ],
            animated: true)
    }
    
    private func createNavigationController(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        
        return nav
    }
    
    private func getHeadlinesViewController() -> UIViewController {
        let viewModel = HeadlinesViewModel(headlines: [])
        let newsHeadlineVC = self.createNavigationController(with: "Headline", and: UIImage(systemName: "newspaper"), viewController: HeadlinesViewController(viewModel: viewModel))
        return newsHeadlineVC
    }
    
    private func getSourcesViewController() -> UIViewController {
        let viewModel = NewsSourcesViewModel(newsSources: [])
        let newsSourcesVC = self.createNavigationController(with: "Sources", and: UIImage(systemName: "checklist"), viewController: NewsSourcesViewController(viewModel: viewModel))
        return newsSourcesVC
    }
}
