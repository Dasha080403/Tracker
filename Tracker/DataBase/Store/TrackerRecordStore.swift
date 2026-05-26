//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Дарья Савинкина on 21.05.2026.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    func fetchRecords() throws -> [Models.TrackerRecord] {
            let request = TrackerRecordCoreData.fetchRequest()
            let recordsCoreData = try context.fetch(request)
            
            return recordsCoreData.compactMap {
                guard let id = $0.id, let date = $0.date else { return nil }
                return Models.TrackerRecord(trackerId: id, date: date)
            }
        }

    func add(_ record: Models.TrackerRecord) throws {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.id = record.trackerId
        recordCoreData.date = record.date
        
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.trackerId as CVarArg)
        if let tracker = try context.fetch(request).first {
            recordCoreData.tracker = tracker
        }
        
        try context.save()
    }

    func remove(_ record: Models.TrackerRecord) throws {
            let request = TrackerRecordCoreData.fetchRequest()
            
            let dateToMatch = Calendar.current.startOfDay(for: record.date)
            
            request.predicate = NSPredicate(format: "id == %@ AND date == %@",
                                            record.trackerId as CVarArg,
                                            dateToMatch as NSDate)
            
            if let recordToDelete = try context.fetch(request).first {
                context.delete(recordToDelete)
                try context.save()
            }
        }
}
