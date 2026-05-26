//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Дарья Савинкина on 22.03.2026.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private let contentView = StatisticsView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    private func setupNavBar() {
        title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
