//
//  ViewController.swift
//  Guess
//
//  Created by Korman Chen on 11/20/17.
//  Copyright © 2017 Korman Chen. All rights reserved.
//

import UIKit
import ChameleonFramework

enum Mode {
    case login
    case register
}

protocol WelcomeDelegate {
    func loadView(navTitle: String, type: Mode)
}

class WelcomeViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    var delegate : WelcomeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = UIColor.flatGray()
        registerButton.backgroundColor = UIColor.flatGray()
        
        loginButton.setTitleColor(UIColor.flatSand(), for: .normal)
        registerButton.setTitleColor(UIColor.flatSand(), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.delegate = segue.destination as! RegisterLoginViewController
    }
    
    //MARK: Actions
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "registerLoginSegue", sender: self)
        
        if sender == loginButton {
            delegate?.loadView(navTitle: "Login", type: .login)
        }
        else {
            delegate?.loadView(navTitle: "Register", type: .register)
        }
    }
    
}

