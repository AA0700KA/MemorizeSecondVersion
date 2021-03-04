//
//  EmodjiMemoryGame.swift
//  MemorizeSecondVersion
//
//  Created by Andrew Bondarenko on 05.01.2021.
//

import SwiftUI


class EmodjiMemoryGame : ObservableObject, Identifiable {
    
    @Published var model : MemorizeGame<String>
    private(set) var emodjis : String
    private(set) var color : ColorsEnum
    
    var id : UUID
    
    var text : String {
        model.text
    }
    
    init(id : UUID? = nil, values : String = "", color : ColorsEnum = ColorsEnum.orange) {
        self.id = id ?? UUID()
        let key = "EmodjiGame \(self.id)"
        let colorKey = "\(key) color"
        
        var colorValue = UserDefaults.standard.string(forKey: colorKey) ?? color.rawValue
        print(colorValue)
        var colorEnum = ColorsEnum.init(rawValue: colorValue)
        
        print(colorEnum)
        
        var emodjis = UserDefaults.standard.string(forKey: key) ?? values
//        print("Id : \(self.id) and key \(key)")
        print("emodjis : \(emodjis)")
        
        if values != "", values != emodjis {
            emodjis = values
        }
        
        model = MemorizeGame<String>(numberPairs: emodjis.count, imageFactory: { (index : Int) -> String in
                                      var array = emodjis.map{String($0)};
                                         return array[index]
                                     })
        
        self.emodjis = emodjis
        self.color = colorEnum ?? color
        UserDefaults.standard.set(emodjis, forKey: key)
        UserDefaults.standard.set(colorValue, forKey: colorKey)

    }
    
    func updateEmodjis(values : String) {
        emodjis = values
        let key = "EmodjiGame \(id)"
        print(key)
        print(emodjis)
        UserDefaults.standard.set(emodjis, forKey: key)
    }
    
    
    var cards : Array<MemorizeGame<String>.Card> {
        return model.cards
    }
    
    func chose(card : MemorizeGame<String>.Card) {
        model.chose(card: card)
    }
    
    func createNewGame()  {
        let emodjis = self.emodjis
        model = MemorizeGame<String>(numberPairs: emodjis.count, imageFactory: { (index : Int) -> String in
            var array = emodjis.map{String($0)};
               return array[index]
           })
    }
    
    
    
}
