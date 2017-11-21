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

class RegisterLoginViewController: UIViewController, UITextFieldDelegate, WelcomeDelegate {
    //MARK: Properties
    private var viewType : Mode = .register
    private var viewTitle : String = "Register"
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    func configureUI() {
        
        navigationItem.title = viewTitle
        loginRegisterButton.backgroundColor = UIColor.flatGray()
        loginRegisterButton.setTitleColor(UIColor.flatSand(), for: .normal)
        
        if viewType == .login {
            loginRegisterButton.titleLabel?.text = "Login"
        }
        else {
            loginRegisterButton.titleLabel?.text = "Register"
        }
    }
    
    @IBAction func loginRegisterPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let name = nameTextField.text, let password = passwordTextField.text {
            
            if viewType == .register {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    
                })
            }
        }
    }
    
    //MARK: Protocol
    func loadView(navTitle: String, type: Mode) {
        
        viewType = type
        viewTitle = navTitle
    }
}
