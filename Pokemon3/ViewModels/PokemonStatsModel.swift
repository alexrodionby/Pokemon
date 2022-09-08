//
//  PokemonStatsModel.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 4.09.22.
//

import Foundation
import Combine
import SwiftUI

class PokemonStatsModel: ObservableObject {
    
    @Published var stats: PokemonStats?
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var isLoadingImage: Bool = false
    
    let dataService: PokemonStatsService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(url: String) {
        self.dataService = PokemonStatsService(url: url)
        addSubscribers()
        self.isLoading = true
        self.isLoadingImage = true
    }
    
    func addSubscribers() {
        dataService.$image
            .sink { [weak self] returnedImage in
                self?.image = returnedImage
                self?.isLoadingImage = false
            }
            .store(in: &cancellables)
        
        dataService.$stats
            .sink { [weak self] returnedStats in
                self?.stats = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
}
