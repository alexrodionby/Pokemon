//
//  Data+PrettyJSON.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 2.09.22.
//

import Foundation

extension Data {
    
    var prettyJSON: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []), //Any
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}
