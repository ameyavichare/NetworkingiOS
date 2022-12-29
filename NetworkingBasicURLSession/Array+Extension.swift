//
//  Array+Extension.swift
//  NetworkingBasicURLSession
//
//  Created by Admin on 25/12/22.
//

import Foundation

extension Array {
    func safelyGetElement(atIndex index: Int?) -> Element? {
        guard let index: Int = index, index >= 0, index < self.count else {
                return nil
        }
        return self[index]
    }
}
