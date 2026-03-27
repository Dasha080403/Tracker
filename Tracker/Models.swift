//
//  Models.swift
//  Tracker
//
//  Created by Дарья Савинкина on 18.03.2026.
//

import UIKit

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник", tuesday = "Вторник", wednesday = "Среда"
    case thursday = "Четверг", friday = "Пятница", saturday = "Суббота", sunday = "Воскресенье"

    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }

    var calendarDayNumber: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]? 
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

struct TrackerRecord: Hashable {
    let trackerId: UUID
    let date: Date
}
