//
//  ThemeLoader.swift
//  MemorizeSecondVersion
//
//  Created by Andrew Bondarenko on 18.02.2021.
//

import Foundation

class ThemeLoader<CardType> where CardType : Equatable {
    
    var model : MemorizeGame<CardType>
    private(set) var emodjis : CardType
    
    init(model : MemorizeGame<CardType>, emodjis : CardType) {
        self.emodjis = emodjis
        self.model = model
    }
    
}

