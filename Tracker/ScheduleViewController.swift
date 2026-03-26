//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Дарья Савинкина on 22.03.2026.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedDays: Set<WeekDay> = []
    
    private let tableView = UITableView()
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Расписание"
        setupUI()
    }
    
    private func setupUI() {
        [tableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            
        }
        
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        doneButton.addTarget(self, action: #selector(doneTap), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneTap() {
        let sortedDays = WeekDay.allCases.filter { selectedDays.contains($0) }
        delegate?.didSelectDays(sortedDays)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let day = WeekDay.allCases[indexPath.row]
        cell.textLabel?.text = day.rawValue
        cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        
        let switchView = UISwitch()
        switchView.onTintColor = .systemBlue
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let day = WeekDay.allCases[sender.tag]
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
}
