//
//  TabBarController.swift
//  Tracker
//
//  Created by Дарья Савинкина on 22.03.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTabs()
    }
    
    private func setupAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(resource: .blue)
        
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.clipsToBounds = true
    }
    
    private func setupTabs() {
        let trackersVC = TrackersViewController()
        let statisticsVC = StatisticsViewController()
        
        let trackersNav = UINavigationController(rootViewController: trackersVC)
        let statisticsNav = UINavigationController(rootViewController: statisticsVC)
        
        trackersNav.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            tag: 0
        )
        
        statisticsNav.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            tag: 1
        )
        
        viewControllers = [trackersNav, statisticsNav]
    }
}

