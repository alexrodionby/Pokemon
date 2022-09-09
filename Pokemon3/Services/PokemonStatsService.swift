//
//  PokemonImageService.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 4.09.22.
//

// MARK: - Сервис доставки данных для страницы с подробностями о покемоне

import Foundation
import Combine
import SwiftUI

class PokemonStatsService {
    
    @Published var image: UIImage? = nil
    @Published var stats: PokemonStats?
    
    var imageSubscription: AnyCancellable?
    var pokemonStatsSubcription: AnyCancellable?
    
    init(url: String) {
        getPokemonStats(url: url)
    }
    
    func getPokemonStats(url: String) {
        guard let url = URL(string: url) else { return }
        pokemonStatsSubcription = NetworkingManager.download(url: url)
            .decode(type: PokemonStats.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] statsValue in
                self?.stats = statsValue
                self?.getPokemonImage(url: statsValue.sprites?.frontDefault ?? "")
                self?.pokemonStatsSubcription?.cancel()
            })
    }
    
    func getPokemonImage(url: String) {
        guard let url = URL(string: url) else { return }
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
    
}
