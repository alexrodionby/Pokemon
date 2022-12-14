//
//  LocalFileManager.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 5.09.22.
//

// MARK: - Локальныйц файловый менеджер

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }
    
    func saveData(dataToSave: Data, fileName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let url = getURLForData(fileName: fileName, folderName: folderName) else { return }
        FileManager.default.createFile(atPath: url.path, contents: dataToSave)
    }
    
    func getData(fileName: String, folderName: String) -> Data? {
        guard let url = getURLForData(fileName: fileName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        var dataFile: Data? = nil
        do {
            try dataFile = Data(contentsOf: url)
        } catch let error {
            print("Error get data \(error)")
        }
        return dataFile
    }
    
    func dataToDictionary(data: Data) -> [String: String] {
        var jsonDictionary: [String: String] = [:]
        do {
            jsonDictionary = try JSONSerialization.jsonObject(with: data) as! [String: String]
        } catch let error {
            print(error.localizedDescription)
        }
        return jsonDictionary
    }
    
    func dictionaryToData(dictionary: [String: String]) -> Data? {
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dictionary)
        } catch let error {
            print(error.localizedDescription)
        }
        return jsonData
    }
    
    func createOfflineFileIfNeeded() {
        createFolderIfNeeded(folderName: "pokemon_cash")
        if getData(fileName: "pokemon_offline", folderName: "pokemon_cash") == nil {
            let emptyDictionary: [String: String] = [:]
            if let data = dictionaryToData(dictionary: emptyDictionary) {
                saveData(dataToSave: data, fileName: "pokemon_offline", folderName: "pokemon_cash")
            }
        }
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName) Error: \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForData(fileName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(fileName)
    }
    
    
}
