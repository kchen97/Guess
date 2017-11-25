//
//  RegisterLoginViewController.swift
//  Guess
//
//  Created by Korman Chen on 11/20/17.
//  Copyright © 2017 Korman Chen. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import PKHUD

protocol RegisterLoginDelegate {
    func loadUser(player: Player)
}

class RegisterLoginViewController: UIViewController, UITextFieldDelegate, WelcomeDelegate {
    //MARK: Properties
    private var viewType : Mode = .register
    private var viewTitle : String = "Register"
    private var somePlayer = Player()
    private var success = false
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let usersDbRef = FIRDatabase.database().reference().child("Users")
    var delegate : RegisterLoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    func configureUI() {
        
        navigationItem.title = viewTitle
        loginRegisterButton.backgroundColor = UIColor.flatGray()
        loginRegisterButton.setTitleColor(UIColor.flatSand(), for: .normal)
        passwordTextField.isSecureTextEntry = true
        
        if viewType == .login {
            loginRegisterButton.setTitle("Login", for: .normal)
            print("In login")
        }
        else {
            loginRegisterButton.setTitle("Register", for: .normal)
            print("In register")
        }
    }
    
    func userExists(name: String, userId: String) -> Player? {
        
        usersDbRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! Dictionary<String, String>
            let playerName = value["Name"]!
            let playerBalance = value["Balance"]!
            
            if playerName == name {
                self.somePlayer = Player(playerName: playerName, playerCash: Int(playerBalance)!)
                self.success = true
            }
        })
        
        if success {
            return somePlayer
        }
        
        return nil
    }
    
    @IBAction func loginRegisterPressed(_ sender: UIButton) {
        
        loginRegisterButton.isEnabled = false
        HUD.show(.progress)
        
        if let email = emailTextField.text, let name = nameTextField.text, let password = passwordTextField.text {
            
            if viewType == .register {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print(error!)
                        self.displayErrorHUD((error?.localizedDescription)!)
                    }
                    else {
                        print("Successfully registered user")
                        let userInfo = ["Name" : name, "Balance" : "0"]
                        let somePlayer = Player(playerName: name, playerCash: 0)
                        self.usersDbRef.child((user?.uid)!).setValue(userInfo)
                        self.moveToGame(player: somePlayer)
                    }
                })
            }
            else {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print(error!)
                        self.displayErrorHUD((error?.localizedDescription)!)
                    }
                    else {
                        if let somePlayer = self.userExists(name: name, userId: (user?.uid)!) {
                            print("Successfully logged in")
                            self.moveToGame(player: somePlayer)
                        }
                        else {
                            self.displayErrorHUD("Incorrect username/password")
                            do {
                                try FIRAuth.auth()?.signOut()
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                })
            }
        }
        
        loginRegisterButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveToGame(player: Player) {
        performSegue(withIdentifier: "gameSegue", sender: self)
        HUD.flash(.success, delay: 1.0)
        delegate?.loadUser(player: player)
    }
    
    func displayErrorHUD(_ subtitle: String) {
        let errorMessageHUD = PKHUDErrorView(title: "Error", subtitle: subtitle)
        PKHUD.sharedHUD.contentView = errorMessageHUD
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2.0)
    }
    
    //MARK: Protocol
    func loadView(navTitle: String, type: Mode) {
        
        viewType = type
        viewTitle = navTitle
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            delegate = segue.destination as! GameViewController
        }
    }
}
