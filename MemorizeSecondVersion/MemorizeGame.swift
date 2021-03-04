//
//  MemorizeGame.swift
//  MemorizeSecondVersion
//
//  Created by Andrew Bondarenko on 05.01.2021.
//

import Foundation

struct MemorizeGame<CardType> where CardType : Equatable {
    
    private(set) var cards : Array<Card>
    private var score = 0
    private(set) var text : String
    
    private var lastChoseIndex : Int? {
        
        get {
            
            
            let faceUpIndexies = cards.indices.filter{index in cards[index].isFaceUp}
            if (faceUpIndexies.count == 1) {
                return faceUpIndexies.first
            } else {
                return nil
            }
        }
        
        set {
            print("Set")
            for index in cards.indices {
                cards[index].isFaceUp = newValue == index
            }
            

        }
        
    }
    
    private mutating func winOrLoseText() {
        let faceUpCards = cards.filter {card in card.isMatched}
        
        if faceUpCards.count == cards.count {
            score *= 2
            
            text = (score >= 0) ? "You win!!!" : "You lose :("
        }
    }

    
    init(numberPairs : Int, imageFactory : (Int) -> CardType ) {
        cards = Array<Card>();
        
        
        for pairIndex in 0..<numberPairs {
            let content = imageFactory(pairIndex)
            let cardFirst = Card(content: content,id: pairIndex*2)
            let cardSecond = Card(content: content,id: pairIndex*2 + 1)
            cards.append(cardFirst)
            cards.append(cardSecond)
        }

        cards.shuffle()
        text = "Your score: \(score)"
    }
    
    mutating func chose(card : Card) {
        let index = cards.firstIndex(matching: card)
        if let currentChosen = lastChoseIndex, !card.isFaceUp, !card.isMatched {
            print("Card chosen \(card)")
            
            if cards[index].content == cards[currentChosen].content {
                cards[index].isMatched = true
                cards[currentChosen].isMatched = true
                cards[currentChosen].countTouch += 1
                cards[index].countTouch += 1
                score += (cards[index].countTouch + cards[currentChosen].countTouch)/2
                text = "Your score : \(score)"
                winOrLoseText()
            }
            

            cards[index].isFaceUp = true
          
        } else {
            lastChoseIndex = index
            score -= cards[index].countTouch
            text = "Your score : \(score)"
            winOrLoseText()
        }
        
        cards[index].countTouch +=  1
        
    }

    
    struct Card : Identifiable {
        var isFaceUp : Bool = false
        var isMatched : Bool = false
        var content : CardType
        var id : Int
        var countTouch = 0

    }
    
}
