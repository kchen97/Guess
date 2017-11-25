//
//  GameViewController.swift
//  Guess
//
//  Created by Korman Chen on 11/22/17.
//  Copyright © 2017 Korman Chen. All rights reserved.
//

import UIKit
import ChameleonFramework

class GameViewController: UIViewController, RegisterLoginDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Properties
    private var currentPlayer = Player()
    private var validGuessCollection = [String]()
    @IBOutlet var labelCollection:[UILabel]!
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var numberPicker: UIPickerView!
    
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
    }
    
    
    func configureUI() {
        
        navigationItem.title = "Hi \(currentPlayer.name)"
        
        for numberLabel in labelCollection {
            
            numberLabel.backgroundColor = UIColor.flatCoffee()
            numberLabel.textColor = UIColor.flatWhite()
            numberLabel.text?.removeAll()
        }
        
        for number in 1...100 {
            validGuessCollection.append(String(number))
        }
    }
    
    //MARK: Delegate Methods
    func loadUser(player: Player) {
        currentPlayer = player
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return validGuessCollection[row]
    }
}
