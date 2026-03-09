//
//  CalendarViewModel.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import Foundation
import CoreData
import Combine

class CalendarViewModel: ObservableObject {
    @Published var stamps: [StampEntry] = []
    @Published var selectedDate: Date = Date()
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
        loadStamps()
    }
    
    func loadStamps() {
        stamps = persistenceController.fetchAllStamps()
    }
    
    func stamp(for date: Date) -> StampEntry? {
        return persistenceController.fetchStamp(for: date)
    }
    
    func deleteStamp(_ stamp: StampEntry) {
        persistenceController.deleteStamp(stamp)
        loadStamps()
    }
}
