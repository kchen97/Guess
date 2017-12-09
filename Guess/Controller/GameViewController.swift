//
//  GameViewController.swift
//  Guess
//
//  Created by Korman Chen on 11/22/17.
//  Copyright © 2017 Korman Chen. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class GameViewController: UIViewController, RegisterLoginDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    private var currentPlayer = Player()
    private var validGuessCollection = [String]()
    private var lotteryGame = Game()
    private var numMatches = 0
    @IBOutlet var labelCollection:[UILabel]!
    @IBOutlet var usersNumbers:[UITextField]!
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var userCashLabel: UILabel!
    
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
    
        numMatches = 0
        
        if canRoll() {
            currentPlayer.cash -= 1
            for label in labelCollection {
                let number = String(arc4random_uniform(100) + 1)
                label.text = number
                lotteryGame.lotteryNumbers[number] = true
            }
            compare()
            updateUI()
        }
    }
    
    func compare() {
        
        for label in usersNumbers {
            if lotteryGame.isLottoNumber((label.text)!) {
                numMatches += 1
            }
        }
        for label in labelCollection {
            lotteryGame.reset((label.text)!)
        }
        
        currentPlayer.cash += numMatches*2
    }
    
    func updateUI() {
        
        userCashLabel.text = "$\(currentPlayer.cash)"
    }
    
    func canRoll() -> Bool {
        
        for textfield in usersNumbers {
            if (textfield.text?.isEmpty)! {
                return false
            }
        }
    
        return currentPlayer.cash > 0
    }
    
    
    func configureUI() {
        
        navigationItem.title = "Hi \(currentPlayer.name)"
        userCashLabel.text = "$\(currentPlayer.cash)"
        rollButton.setTitle("Roll", for: .normal)
        rollButton.backgroundColor = UIColor.flatNavyBlue()
        rollButton.setTitleColor(UIColor.flatWhiteColorDark(), for: .normal)
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
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
//        let userRefDB = FIRDatabase.database().reference().child("Users")
//        if let currentUserId = FIRAuth.auth()?.currentUser?.uid {
//            userRefDB.child(currentUserId).setValue(String(currentPlayer.cash), forKey: "Balance")
//        }
        
        do {
            try FIRAuth.auth()?.signOut()
        }
        catch {
            print(error)
        }
        
        guard navigationController?.popToRootViewController(animated: true) != nil else {
            return
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
