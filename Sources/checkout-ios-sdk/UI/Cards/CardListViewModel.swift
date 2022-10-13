//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation

struct CardListViewModel {

    var cards = [Card]()

    var count: Int {
        return cards.count
    }

    init() {
    }

    func card(at index: Int) -> Card {
        return cards[index]
    }

    func fetchCards() {
        
    }
}
