//
//  Game.swift
//  Guess
//
//  Created by Korman Chen on 12/8/17.
//  Copyright © 2017 Korman Chen. All rights reserved.
//

import Foundation

class Game {
    var lotteryNumbers = [String : Bool]()
    
    init() {
        for number in 1...100 {
            lotteryNumbers[String(number)] = false
        }
    }
    
    func isLottoNumber(_ number : String) -> Bool {
        
        if lotteryNumbers.index(forKey: number) != nil && lotteryNumbers[String(number)]! {
            lotteryNumbers.updateValue(false, forKey: number)
            return true
        }
        
        return false
    }
    
    func reset(_ number : String) {
        lotteryNumbers[number] = false
    }
}
