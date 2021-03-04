//
//  Array+Identifielble.swift
//  MemorizeSecondVersion
//
//  Created by Andrew Bondarenko on 15.01.2021.
//

import Foundation

extension Array where Element : Identifiable {
    
    func firstIndex(matching : Element) -> Int {
        for index in 0..<count {
            if self[index].id == matching.id {
                return index
            }
        }
        return 0
    }
    
    func chunk(size: Int) -> [[Element]] {
        
        var result = [[Element]]()
        
        for index in stride(from: 0, to: count, by: size) {
            var array = [Element]()
            
            var end = index + size
            
            if end > count {
                end = count
            }
            
            for idx in index..<end {
                array.append(self[idx])
            }
            
            result.append(array)
            
            
        }
        
        return result
    }
    
}
