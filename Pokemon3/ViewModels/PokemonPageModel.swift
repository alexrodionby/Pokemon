//
//  PokemonViewModel.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 2.09.22.
//

import Foundation
import Combine

class PokemonPageModel: ObservableObject {
    
    @Published var page: PokemonPage?
    @Published var isLoading: Bool = false
    
    let dataService = PokemonPageService(url: "https://pokeapi.co/api/v2/pokemon")
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        self.isLoading = true
    }
    
    func addSubscribers() {
        dataService.$page
            .sink { [weak self] returnedPage in
                self?.page = returnedPage
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
}
