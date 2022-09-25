//
//  LocalSharedMediaDataService.swift
//  Albumer
//
//  Created by Marjan Khodadad on 9/24/22.
//

import Foundation
import CoreData

class LocalSharedMediaDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "Albumer"
    private let entityName: String = "SharedMediaEntity"
    
    private let mediasDataService = SharedMediaDataService()
    
    @Published var savedEntities: [SharedMediaModel] = []
    
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getSharedMedias()
        }
    }
    
    // MARK: PUBLIC
    
    //    func updatePortfolio(coin: SharedMediaModel) {
    //        // check if coin is already in portfolio
    //        if let entity = savedEntities.first(where: { $0.imageID == coin.id }) {
    //            update(entity: entity, size: coin.size!)
    //        } else {
    //            add(coin: coin, size: coin.size!)
    //        }
    //    }
    
    //    func getSharedMedias(){
    //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    //            fetchRequest.returnsObjectsAsFaults = false
    //            do {
    //                let results = try container.viewContext.fetch(fetchRequest)
    //                for object in results {
    //                    guard let objectData = object as? NSManagedObject else {continue}
    //                    container.viewContext.delete(objectData)
    //                }
    //            } catch let error {
    //                print("Detele all data in \(entityName) error :", error)
    //            }
    //    }
    
    func reloadData() {
        clearAll()
        loadFromServer()
        
        
    }
    
    
    // MARK: PRIVATE
    
    private func getSharedMedias() {
        let request = NSFetchRequest<SharedMediaEntity>(entityName: entityName)
        do {
            let entities = try container.viewContext.fetch(request)
            if entities.count > 0 {
                savedEntities = entities.map({SharedMediaModel(id: $0.imageID, userId: "", mediaType: .image, filename: "", size: 10, createdAt: "", takenAt: "", guessedTakenAt: "", md5Sum: "", contentType: "", video: "", thumbnailURL: $0.thumbnailUrl, downloadURL: "", resx: 10, resy: 100)})
                return
            }else {
                loadFromServer()
            }
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
        
       
    }
    
    
    
    private func clearAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                container.viewContext.delete(objectData)
            }
            save()
        } catch let error {
            print("Detele all data in \(entityName) error :", error)
        }
    }
    
    private func loadFromServer() {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                for item in response {
                    self.add(coin: item, size: item.size ?? 0)
                }
                self.applyChanges()
                
            case .failure(_): break
                
            }
        }
    }
    
    private func fetchData(completion: @escaping (Result<[SharedMediaModel], RequestError>) -> Void) {
        Task(priority: .high) {
            let result = await SharedMediaService().getSharedMedias(shareKey: "djlCbGusTJamg_ca4axEVw")
            completion(result)
        }
    }
    
    private func add(coin: SharedMediaModel, size: Int) {
        let entity = SharedMediaEntity(context: container.viewContext)
        entity.imageID = coin.id
        entity.thumbnailUrl = coin.thumbnailURL
        entity.size = Int64(size)
    }
    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getSharedMedias()
    }
    
    
    
}
