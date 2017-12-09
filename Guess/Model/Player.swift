//
//  Player.swift
//  Guess
//
//  Created by Korman Chen on 11/21/17.
//  Copyright © 2017 Korman Chen. All rights reserved.
//

import Foundation

class Player {
    var name : String
    var cash : Int
    
    init() {
        name = ""
        cash = 0
    }
    
    convenience init(playerName : String) {
        self.init()
        name = playerName
    }
    
    convenience init(playerName : String, playerCash : Int) {
        self.init()
        name = playerName
        cash = playerCash
    }
    
}
