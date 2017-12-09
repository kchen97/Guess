//
//  GameViewController.swift
//  Guess
//
//  Created by Korman Chen on 11/22/17.
//  Copyright © 2017 Korman Chen. All rights reserved.
//

import UIKit
import ChameleonFramework

class GameViewController: UIViewController, RegisterLoginDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    private var currentPlayer = Player()
    private var validGuessCollection = [String]()
    private var lotteryGame = Game()
    @IBOutlet var labelCollection:[UILabel]!
    @IBOutlet var usersNumbers:[UITextField]!
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var numMatchesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func rollPressed(_ sender: UIButton) {
    
        if canRoll() {
            for label in labelCollection {
                let number = String(arc4random_uniform(100) + 1)
                label.text = number
                lotteryGame.lotteryNumbers[number] = true
            }
            compare()
        }
    }
    
    func compare() {
        
        var numMatches = 0
        
        for label in usersNumbers {
            if lotteryGame.isLottoNumber((label.text)!) {
                numMatches += 1
            }
        }
        for label in labelCollection {
            lotteryGame.reset((label.text)!)
        }
        
        numMatchesLabel.text = String(numMatches)
    }
    
    func canRoll() -> Bool {
        
        for textfield in usersNumbers {
            if (textfield.text?.isEmpty)! {
                return false
            }
        }
        return true
    }
    
    
    func configureUI() {
        
        navigationItem.title = "Hi \(currentPlayer.name)"
        numMatchesLabel.text = "0"
        rollButton.setTitle("Roll", for: .normal)
        view.backgroundColor = UIColor.flatOrangeColorDark()
        
        for numberLabel in labelCollection {
            
            numberLabel.backgroundColor = UIColor.flatWhite()
            numberLabel.textColor = UIColor.flatOrangeColorDark()
            numberLabel.text?.removeAll()
        }
        
        for number in 1...100 {
            validGuessCollection.append(String(number))
        }
        
        for textfield in usersNumbers {
            textfield.delegate = self
        }
    }
    
    //MARK: Delegate Methods
    func loadUser(player: Player) {
        currentPlayer = player
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
