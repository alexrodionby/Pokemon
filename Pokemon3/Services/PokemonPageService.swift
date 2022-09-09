//
//  PokemonPageService.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 4.09.22.
//

// MARK: - Сервис доставки данных для главного экрана

import Foundation
import Combine

class PokemonPageService {
    
    @Published var page: PokemonPage? = nil
    
    var pokemonPageSubscription: AnyCancellable?
    
    init(url: String) {
        getPage(url: url)
    }
    
    func getPage(url: String) {
        LocalFileManager.instance.createOfflineFileIfNeeded()
        
        guard let dataOfOfflineDictionary = LocalFileManager.instance.getData(fileName: "pokemon_offline", folderName: "pokemon_cash") else { return }
        var offlineDictionary = LocalFileManager.instance.dataToDictionary(data: dataOfOfflineDictionary)
        
        guard let url = URL(string: url) else { return }
        
        var loadFlag = 0
        for item in offlineDictionary {
            if item.key == url.absoluteString {
                print("страница уже есть в словаре", url.absoluteString)
                loadFlag = 1
            }
        }
        
        if loadFlag == 1 {
            guard let offlinedata = LocalFileManager.instance.getData(fileName: offlineDictionary[url.absoluteString] ?? "", folderName: "pokemon_cash") else { return }
            do {
                self.page = try JSONDecoder().decode(PokemonPage.self, from: offlinedata)
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            
            offlineDictionary[url.absoluteString] = String(offlineDictionary.count + 1)
            guard let newData = LocalFileManager.instance.dictionaryToData(dictionary: offlineDictionary) else { return }
            LocalFileManager.instance.saveData(dataToSave: newData, fileName: "pokemon_offline", folderName: "pokemon_cash")
            
            pokemonPageSubscription = NetworkingManager.download(url: url)
                .decode(type: PokemonPage.self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] pageValue in
                    self?.page = pageValue
                    self?.pokemonPageSubscription?.cancel()
                })
        }
    }
    
}
