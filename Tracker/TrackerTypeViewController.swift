//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Дарья Савинкина on 19.03.2026.
//

import UIKit

protocol TrackerTypeViewControllerDelegate: AnyObject {
    func didSelectType(_ type: TrackerType)
}

enum TrackerType {
    case habit
    case irregular
}

final class TrackerTypeViewController: UIViewController {
    
    weak var delegate: TrackerTypeViewControllerDelegate?
    
    // MARK: - UI Elements
    private let habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .ypBlack // Ваш цвет из ассетов
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapHabit), for: .touchUpInside)
        return button
    }()
    
    private let irregularButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapIrregular), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Создание трекера"
        
        [habitButton, irregularButton].forEach { stackView.addArrangedSubview($0) }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 136) // 60 + 16 + 60
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapHabit() {
        let createVC = TrackerCreationViewController()
        createVC.isHabit = true
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    @objc private func didTapIrregular() {
        let createVC = TrackerCreationViewController()
        createVC.isHabit = false
        navigationController?.pushViewController(createVC, animated: true)
    }
}

