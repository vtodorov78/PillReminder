//
//  Medication+CoreDataProperties.swift
//  PillReminder
//
//  Created by Vladimir Todorov on 19.11.23.
//
//

import Foundation
import CoreData


extension Medication {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
        return NSFetchRequest<Medication>(entityName: "Medication")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var date: Date
    @NSManaged public var isMarked: Bool
    @NSManaged public var title: String

}

extension Medication : Identifiable {

}
