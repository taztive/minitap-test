//
//  StampCreationViewModel.swift
//  Nooka
//
//  Created by Nooka on 2024.
//

import Foundation
import UIKit
import Combine

class StampCreationViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var title: String = ""
    @Published var note: String = ""
    @Published var selectedDate: Date = Date()
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }
    
    func createStamp() -> Bool {
        guard let image = selectedImage,
              !title.isEmpty,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return false
        }
        
        _ = persistenceController.createStamp(
            date: selectedDate,
            photoData: imageData,
            title: title,
            note: note.isEmpty ? nil : note
        )
        
        reset()
        return true
    }
    
    func reset() {
        selectedImage = nil
        title = ""
        note = ""
        selectedDate = Date()
    }
}
