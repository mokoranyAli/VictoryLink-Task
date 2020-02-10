//
//  loginViewController.swift
//  VictoryLinkTask
//
//  Created by Mohamed Korany Ali on 2/10/20.
//  Copyright © 2020 Mohamed Korany Ali. All rights reserved.
//

import UIKit
import AnAlertView
import FirebaseAuth

enum ValidationError: Error {
    case tooShort
    case tooLong
    case invalidCharacterFound(Character)
    
}



class loginViewController: UIViewController , AlertViewDelegate  {
  
    
   
    
    
   
    
    func dismissButtonTapped(_ button: UIButton) {
        self.username.text = ""
        self.password.text = ""
    }
    
    @IBOutlet weak var username: DesignableUITextField!
    
    @IBOutlet weak var password: DesignableUITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let customColor = UIColor.white
        username.layer.borderColor = customColor.cgColor
        password.layer.borderColor = customColor.cgColor
        
        username.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
       
    }
    
    
    @IBAction func didSignUpPressed(_ sender: Any) {
        
        let viewcontroler = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(registerViewController.self)") as! registerViewController
        print("Asd")
        
        navigationController?.pushViewController(viewcontroler, animated: true)
        

    }
    
    @IBAction func didLoginPressed(_ sender: Any) {
        
        guard let user = self.username.text else { return  }
                   guard let pass = self.password.text else { return  }
        do {
           
            try self.validate(username: user ) {
                print($0)
                
            }

           } catch {

            AlertView.showAlert(message: error.localizedDescription, button: "ok", delegate: self, container: self, image: UIImage(named: "warning"))
            return
           }
        
       
                Auth.auth().signIn(withEmail: user, password: pass) { [weak self] (user, error) in
                    
                    guard let mySelf = self else{return}
                    
                    if let error = error {
                      AlertView.showAlert(message: error.localizedDescription, button: "ok", delegate: self, container: mySelf, image: UIImage(named: "warning"))
                        return
                    }
                    
                   
                    mySelf.showHomeScreen()
                             
                   
                }
            }
        
    func showHomeScreen(){
         let viewcontroler = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(homeViewController.self)") as! homeViewController
         navigationController?.pushViewController(viewcontroler, animated: true)
    }
        
    
    
 
    func validate(username: String,then handler: @escaping (ValidationError?) -> Void) throws {
        guard username.count > 3 else {
            throw ValidationError.tooShort
        }
        
        guard username.count < 25 else {
            throw ValidationError.tooLong
        }
        
//        for character in username {
//            guard character.isLetter else {
//                throw ValidationError.invalidCharacterFound(character)
//            }
//        }
    }

}






extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .tooShort:
            return NSLocalizedString(
                "Your username needs to be at least 4 characters long",
                comment: ""
            )
        case .tooLong:
            return NSLocalizedString(
                "Your username can't be longer than 24 characters",
                comment: ""
            )
        case .invalidCharacterFound(let character):
            let format = NSLocalizedString(
                "Your username can't contain the character '%@'",
                comment: ""
            )

            return String(format: format, String(character))
        }
    }
}

