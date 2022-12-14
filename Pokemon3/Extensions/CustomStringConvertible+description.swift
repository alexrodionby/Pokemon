//
//  CustomStringConvertible+description.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 2.09.22.
//

// MARK: - Дополнение для лучшего отображения данных

import Foundation

extension CustomStringConvertible where Self: Codable {
    
    var description: String {
        var description = "\n \(type(of: self)) \n"
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }
        return description
    }
}
