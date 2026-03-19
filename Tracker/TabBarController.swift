//
//  TackerVIewController.swift
//  Tracker
//
//  Created by Дарья Савинкина on 04.03.2026.
//
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(resource: .blue)
        
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
