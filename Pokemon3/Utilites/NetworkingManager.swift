//
//  NetworkingManager.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 3.09.22.
//

// MARK: - Менеджер сетевых загрузок

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingErrors: LocalizedError {
        case badURLResponse(url: URL)
        case unknow
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[🔥] Bad response from URL: \(url)"
            case .unknow:
                return "[⚠️] Unknow error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingErrors.badURLResponse(url: url)
        }
        let dataOfOfflineDictionary = LocalFileManager.instance.getData(fileName: "pokemon_offline", folderName: "pokemon_cash")
        let offlineDictionary = LocalFileManager.instance.dataToDictionary(data: dataOfOfflineDictionary!)
        LocalFileManager.instance.saveData(dataToSave: output.data, fileName: String(offlineDictionary.count), folderName: "pokemon_cash")
        let newDictionary = LocalFileManager.instance.dictionaryToData(dictionary: offlineDictionary)
        LocalFileManager.instance.saveData(dataToSave: newDictionary!, fileName: "pokemon_offline", folderName: "pokemon_cash")
        return output.data
    }
    
    static func handleComplition(complition: Subscribers.Completion<Error>) {
        switch complition {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }

}
