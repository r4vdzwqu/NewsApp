//
//  SavedArticlesViewController.swift
//  NewsApp
//
//  Created by Melvin K on 4/3/2024.
//

import UIKit

class TabBarCoordinator: NSObject, UITabBarControllerDelegate {
    var tabBarController: UITabBarController
    var viewModels: [TabBarViewModel] = []

    override init() {
        tabBarController = UITabBarController()
        super.init()
        tabBarController.delegate = self
        setupViewControllers()
    }

    private func setupViewControllers() {
        // Instantiate each ViewModel and View Controller here, and add them to the tabBarController
    }

    // Implement any necessary UITabBarControllerDelegate methods here
}



