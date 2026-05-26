//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Дарья Савинкина on 21.05.2026.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore() 

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    func fetchCategories() throws -> [Models.TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let categoriesCoreData = try context.fetch(request)
        
        return try categoriesCoreData.map { categoryCoreData in
            let trackersCoreData = categoryCoreData.trackers?.allObjects as? [TrackerCoreData] ?? []
            let trackers = try trackersCoreData.map { try trackerStore.tracker(from: $0) }
            return Models.TrackerCategory(title: categoryCoreData.title ?? "", trackers: trackers)
        }
    }

    func addTracker(_ tracker: Models.Tracker, to categoryTitle: String) throws {
        let category = try fetchCategory(with: categoryTitle) ?? TrackerCategoryCoreData(context: context)
        category.title = categoryTitle
        
        let trackerCoreData = try trackerStore.makeTracker(from: tracker)
        category.addToTrackers(trackerCoreData)
        
        try context.save()
    }
    
    private func fetchCategory(with title: String) throws -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        return try context.fetch(request).first
    }
}
