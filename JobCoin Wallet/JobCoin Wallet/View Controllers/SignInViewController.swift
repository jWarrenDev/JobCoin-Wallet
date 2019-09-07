//
//  SignInViewController.swift
//  JobCoin Wallet
//
//  Created by Jerrick Warren on 9/2/19.
//  Copyright © 2019 Jerrick Warren. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    var allTransactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        APIService.shared.getTransactions {  [weak self] result in
           
            switch result {
            case .failure(let error):
                print(error)
            case .success(let transactions):
                self?.allTransactions = transactions
            }
        }
    }

  
    @IBOutlet weak var loginButton: JWButton!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        guard let user = userNameTextField.text, !user.isEmpty else {
            
            displayMessage(title: "The address field empty", msg: "Please Try Again")
            self.loginButton.shake()
            return
        }
        
        let users = Set(allTransactions.compactMap({ $0.toAddress ?? $0.fromAddress }))
       
        for user in users {
            if userNameTextField.text == user {
                self.performSegue(withIdentifier:"usersegue", sender: UIButton.self)
                
            } else {
                guard let user = userNameTextField.text else {return}
                displayMessage(title: "The Address \(user) is not correct or found", msg: "Please Try again")
            }
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        userNameTextField.resignFirstResponder()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "usersegue" {
            let destinationVC : TransactionViewController = segue.destination as! TransactionViewController
            destinationVC.user = userNameTextField.text! 
        
        }
    }
}


    

