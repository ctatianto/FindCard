//
//  Card.swift
//  FindCard
//
//  Created by Chandra Agus on 25/4/20.
//  Copyright © 2020 Chandra Agus Tatianto. All rights reserved.
//

import UIKit

class Card {

    // MARK: - Properties
    
    var id: String
    var shown: Bool = false
    var number: Int!
    
    static var allCards = [Card]()

    init(card: Card) {
        self.id = card.id
        self.shown = card.shown
        self.number = card.number
    }
    
    init(number: Int) {
        self.id = NSUUID().uuidString
        self.shown = false
        self.number = number
    }
    
    // MARK: - Methods
    
    func equals(_ card: Card) -> Bool {
        return (card.id == id)
    }
    
    func copy() -> Card {
        return Card(card: self)
    }
}

extension Array {
    mutating func shuffle() {
        for _ in 0...self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
