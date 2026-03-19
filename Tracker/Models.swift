//
//  Models.swift
//  Tracker
//
//  Created by Дарья Савинкина on 18.03.2026.
//

import UIKit

// MARK: - WeekDay (Вспомогательная сущность для расписания)
enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    static func from(date: Date) -> WeekDay? {
           let calendar = Calendar.current
           let weekday = calendar.component(.weekday, from: date)
           switch weekday {
           case 1: return .sunday
           case 2: return .monday
           case 3: return .tuesday
           case 4: return .wednesday
           case 5: return .thursday
           case 6: return .friday
           case 7: return .saturday
           default: return nil
           }
       }
}

// MARK: - Tracker
struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]? 
}

// MARK: - TrackerCategory
struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}

// MARK: - TrackerRecord
struct TrackerRecord: Hashable {
    let trackerId: UUID
    let date: Date
}
