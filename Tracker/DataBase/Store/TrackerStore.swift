//
//  TrackerStore.swift
//  Tracker
//
//  Created by Дарья Савинкина on 21.05.2026.
//

import CoreData
import UIKit

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    func tracker(from coreData: TrackerCoreData) throws -> Models.Tracker {
        guard let id = coreData.id,
              let name = coreData.name,
              let emoji = coreData.emoji,
              let color = coreData.colour as? UIColor else {
            throw NSError(domain: "TrackerStore", code: 0, userInfo: [NSLocalizedDescriptionKey: "Decode error"])
        }
        
        let scheduleString = coreData.schedule ?? ""
        let schedule = scheduleString.split(separator: ",").compactMap { Int($0) }.compactMap { Models.WeekDay(rawValue: $0) }

        return Models.Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }

    func makeTracker(from tracker: Models.Tracker) throws -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        
        trackerCoreData.colour = tracker.color
        
        trackerCoreData.schedule = tracker.schedule?.map { String($0.rawValue) }.joined(separator: ",")
        return trackerCoreData
    }
}
