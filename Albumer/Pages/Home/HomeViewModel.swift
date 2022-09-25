//
//  HomeViewModel.swift
//  Albumer
//
//  Created by Marjan Khodadad on 9/21/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allMedia: [SharedMediaModel] = []
    @Published var isLoading: Bool = false
    
    private let localMediaService = LocalSharedMediaDataService()
    private let fileManager = LocalFileManager.instance
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        localMediaService.$savedEntities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (returnedMedias) in
                self?.isLoading = false
                self?.allMedia = returnedMedias
            }.store(in: &cancellables)
    }
    
    func reloadData() {
        isLoading = true
        fileManager.clearSavedImages(folderName: .sharedImages)
        localMediaService.reloadData()
        
    }
}

