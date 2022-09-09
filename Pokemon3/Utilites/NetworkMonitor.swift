//
//  NetworkMonitor.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 9.09.22.
//

// MARK: - Сервис мониторинга наличия интернета

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    
    @Published private(set) var isConnected = false
    @Published private(set) var isCellular = false
    @Published private(set) var isDisconnected = false
    
    private let nwMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()
    
    public func start() {
        nwMonitor.start(queue: workerQueue)
        nwMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.usesInterfaceType(.wifi)
                self?.isDisconnected = path.status == .unsatisfied
                self?.isCellular = path.usesInterfaceType(.cellular)
            }
        }
    }
    
    public func stop() {
        nwMonitor.cancel()
    }
    
}
