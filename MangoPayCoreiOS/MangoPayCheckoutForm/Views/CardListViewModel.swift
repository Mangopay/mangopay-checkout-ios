//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation

struct CardListViewModel {

    var cards = CardType.allCases.filter({$0 == .visa || $0 == .mastercard})

    var count: Int {
        return cards.count
    }

    init() {
    }

    func card(at index: Int) -> CardType {
        return cards[index]
    }

    func fetchCards() {
        
    }

    mutating func setCards(with card: CardConfig?) {
        guard let _cards = card?.supportedCardBrands else { return }
        self.cards = _cards
    }
}
