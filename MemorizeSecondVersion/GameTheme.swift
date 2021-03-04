//
//  GameTheme.swift
//  MemorizeSecondVersion
//
//  Created by Andrew Bondarenko on 16.02.2021.
//

import Foundation
import Combine

class GameTheme : ObservableObject {
    
    @Published private var gameThemes = [String:EmodjiMemoryGame]()
    
    private var autosave: AnyCancellable?
    
    init() {
        let key = "GameTheme_KEY"
        gameThemes = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: key))
        
        autosave = $gameThemes.sink { themes in
            UserDefaults.standard.set(themes.asPropertyList, forKey: key)
        }
        
        if gameThemes.count == 0 {
            gameThemes["Test"] = EmodjiMemoryGame(values: "👻🎃🚗🚜🚓🕷")
        }
        
    }
    
    var themesNames : [String] {
        gameThemes.keys.sorted { $0 < $1 }
    }
    
    var countThemes : Int {
        gameThemes.count
    }
    
    func changeTheme(oldKey : String, newKey : String, newElements : String, color : ColorsEnum) {
        removeTheme(key: oldKey)
        var result = newElements.count > 12 ? String(newElements[0..<12]) : newElements
        result = result.replacingOccurrences(of: " ", with: "")
        result = result.count >= 2 ? result : "NULL"
        gameThemes[newKey] = EmodjiMemoryGame(values: result, color: color)
    }
    
    func addTheme(key : String, elements : String, color : ColorsEnum) {
        var result = elements.count > 12 ? String(elements[0..<12]) : elements
        result = result.replacingOccurrences(of: " ", with: "")
        result = result.count >= 2 ? result : "NULL"
        gameThemes[key] = EmodjiMemoryGame(values: result, color: color)
    }
    
    func getTheme(key : String) -> EmodjiMemoryGame? {
        return gameThemes[key]
    }
    
    func removeTheme(key : String) {
        gameThemes[key] = nil
    }
    
    
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension Dictionary where Key == String, Value == EmodjiMemoryGame {
    
    var asPropertyList: [String:String] {
        var uuidToName = [String:String]()
        
        for (key, value) in self {
            uuidToName[key] = value.id.uuidString
        }
        
        return uuidToName
    }
    
    init(fromPropertyList plist: Any?) {
        self.init()
        let uuidToName = plist as? [String:String] ?? [:]
        
         print(uuidToName)
        
        for (key, value) in uuidToName {
            print(value)
            self[key] = EmodjiMemoryGame(id: UUID(uuidString: value))
        }
        
    }
    
}
