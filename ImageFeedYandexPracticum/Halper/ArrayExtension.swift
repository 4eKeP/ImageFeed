//
//  Array+Extension.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.11.2023.
//

import Foundation

extension Array {
    mutating func withReplaced(itemAt index: Int, newValue: Element) -> [Element]{
        guard index >= 0, index < self.count else {
            print("индекс выходит за пределы последовательности")
            return self
        }
        var newArray = self
        newArray[index] = newValue
        return newArray
    }
}
