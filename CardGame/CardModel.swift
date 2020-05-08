//
//  CardModel.swift
//  CardGame
//
//  Created by eyal avisar on 06/05/2020.
//  Copyright © 2020 eyal avisar. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        var generatedCards = [Card]()
        
        while generatedCards.count < 16 {
            let card1 = Card()
            let card2 = Card()
            let number = Int.random(in: 1...13)
            card1.imageName = "card\(number)"
            card2.imageName = "card\(number)"
            var contained = false
            for index:Int in 0..<generatedCards.count {
                if generatedCards[index].imageName == card1.imageName {
                    contained = true
                }
            }
            if !contained {
                generatedCards += [card1, card2]
                print(number)
            }
        }
        
        generatedCards.shuffle()
        
        return generatedCards
    }
}
