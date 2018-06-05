//
//  palyingcarddeck.swift
//  palycards
//
//  Created by Arpit Singh on 11/02/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import Foundation
struct playingcarddeck {
    private(set) var card = [playingcard]()
    
     init() {
     for suit in playingcard.Suit.all
     {
        for rank in playingcard.Rank.all
     
     {
        card.append(playingcard(suit: suit, rank: rank))
        }
        
        }
    }
    
    mutating func draw() -> playingcard? {
        if card.count > 0
        {
            return card.remove(at: card.count.acr4random)
        }else{
            return nil
        }
    }
}
extension Int{
    var acr4random :Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else
            if self < 0{
                return -Int(arc4random_uniform(UInt32(self)))
            }else
            {
                return 0
        }
    }
}
