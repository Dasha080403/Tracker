//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Дарья Савинкина on 22.03.2026.
//
import UIKit

final class TrackerTypeViewController: UIViewController {
    private let contentView = TrackerTypeView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая привычка"
    }
}
