//
//  Medication.swift
//  PillReminder
//
//  Created by Vladimir Todorov on 23.08.23.
//

import Foundation

class Medication {
    
    let title: String
    let amount: String
    let date: Date
    var isMarked = false
    
    init(title: String, amount: String, date: Date) {
        self.title = title
        self.amount = amount
        self.date = date
    }
}
