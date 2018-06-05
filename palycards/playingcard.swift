//
//  playingcard.swift
//  palycards
//
//  Created by Arpit Singh on 11/02/18.
//  Copyright © 2018 Arpit Singh. All rights reserved.
//

import Foundation
struct playingcard : CustomStringConvertible{
    var description: String {return "\(rank)\(suit)" }
    
    var suit : Suit
    var rank : Rank
    
    enum Suit : String ,CustomStringConvertible {
        var description: String {
            switch self {
            case .spades:
                return "♠️"
            case .cluds :
                 return "♣️"
            case .diamonds : return "♦️"
            case .heart : return "♥️"
            }
        }
        

        
        
        case spades = "♠️"
        case heart = "♥️"
        case diamonds = "♦️"
        case cluds = "♣️"
        
        
       static var all = [Suit.spades,.heart,.diamonds,.cluds]
    }
    enum Rank : CustomStringConvertible{
        var description: String{
            switch self {
            case .ace:
                return "A"
            case .face(let kind):
                return kind
            case .numeric(let pips) : return String(pips)
            }
        }
        
        
        case ace
        case face(String)
        case numeric(Int)
        
        
        var order : Int {
            switch self {
            case .ace : return 1
            case .numeric(let pips) : return pips
            case .face(let kind) where kind == "j": return 11
            case .face(let kind) where kind == "q": return 12
            case .face(let kind) where kind == "k": return 13
            default: return 0
            }
        }
        static var all : [Rank]{
            var allrank = [Rank.ace]
            for pips in 2...10
            {
                allrank.append(Rank.numeric(pips))
            }
            allrank += [Rank.face("j"),Rank.face("q"),Rank.face("k")]
            return allrank
        }
    }

}
