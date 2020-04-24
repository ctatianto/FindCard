//
//  APIClient.swift
//  FindCard
//
//  Created by Chandra Agus on 25/4/20.
//  Copyright © 2020 Chandra Agus Tatianto. All rights reserved.
//

import Foundation

typealias CardsArray = [Card]

// MARK: - APIClient
class APIClient {
    
    static let shared = APIClient()
    static var cardNumberCollection:[Int] = []
    
    func getCards(completion: ((CardsArray?, Error?) -> ())?) {
        let pairCount = 5
        var cards = CardsArray()
        for i in 1...pairCount {
            APIClient.cardNumberCollection.append(i)
        }
        let cardNumbers = APIClient.cardNumberCollection
        
        for number in cardNumbers {
            let card = Card(number: number)
            let copy = card.copy()
            
            cards.append(card)
            cards.append(copy)
        }
        
        completion!(cards, nil)
    }
}
