//
//  CoreDataManager.swift
//  PillReminder
//
//  Created by Vladimir Todorov on 19.11.23.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                print("Error occured while saving data: \(error.localizedDescription)")
            }
        }
    }
    
    
    func createMedication(title: String, amount: Int, Date: Date) -> Medication{
        let medication = Medication(context: context)
        medication.title = title
        medication.amount = Int16(amount)
        medication.date = Date
        medication.isMarked = false
        save()
        return medication
    }
    
    
    func update(medication: Medication, newTitle: String, newAmount: Int, newDate: Date) {
        medication.title = newTitle
        medication.amount = Int16(newAmount)
        medication.date = newDate
        save()
    }
    
    func delete(medication: Medication) {
        context.delete(medication)
        save()
    }
    
    
}
