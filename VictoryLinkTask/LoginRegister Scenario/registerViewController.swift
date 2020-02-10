//
//  registerViewController.swift
//  VictoryLinkTask
//
//  Created by Mohamed Korany Ali on 2/10/20.
//  Copyright © 2020 Mohamed Korany Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import AnAlertView

class registerViewController: UIViewController  , AlertViewDelegate{
    
    var ref: DatabaseReference!
    @IBOutlet weak var email: DesignableUITextField!
    @IBOutlet weak var userName: DesignableUITextField!
    
    @IBOutlet weak var password: DesignableUITextField!
    @IBOutlet weak var repeatedPassword: DesignableUITextField!
    @IBAction func backButtonPressed(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    func dismissButtonTapped(_ button: UIButton) {
        email.text = ""
        password.text = ""
        repeatedPassword.text = ""
    }
    
    func showErrorAlert(error: String) {
        AlertView.showAlert(message: error, button: "ok", delegate: self, container: self, image: UIImage(named: "warning"))
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customColor = UIColor.white
        
        
        
        email.layer.borderColor = customColor.cgColor
        userName.layer.borderColor = customColor.cgColor
        password.layer.borderColor = customColor.cgColor
        repeatedPassword.layer.borderColor = customColor.cgColor
        
        email.layer.borderWidth = 1.0
        userName.layer.borderWidth = 1.0
        
        password.layer.borderWidth = 1.0
        repeatedPassword.layer.borderWidth = 1.0
        repeatedPassword.layer.borderWidth = 1.0
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        
        
        if userName.text == "" {
            AlertView.showAlert(message: "make username", button: "ok", delegate: self, container: self, image: UIImage(named: "warning"))
        }
        self.showActivityIndicator()
        if password.text == repeatedPassword.text {
            
            ref = Database.database().reference()
            Auth.auth().createUser(withEmail: self.email.text ?? "", password: password.text ?? "") {[weak self] (user, error) in
                
                guard let mySelf = self else {return}
                if let error = error {
                    AlertView.showAlert(message: error.localizedDescription , button: "ok", delegate: self, container: mySelf, image: UIImage(named: "warning"))
                    
                }
                else {
                    
                    
                    mySelf.ref.child("data/users").updateChildValues(["\(Auth.auth().currentUser!.uid)":["Email":mySelf.email.text ,"Username":mySelf.userName.text]])
                    mySelf.hideActivityIndicator()
                    
                    mySelf.showHomePage()
                    
                    
                    
                }
            }
        }
            
            
        else {
            AlertView.showAlert(message: "Password Dosn't Match", button: "ok", delegate: self, container: self, image: UIImage(named: "warning"))
        }
    }
    
    func showHomePage() {
        
         let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(homeViewController.self)") as! homeViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
}
