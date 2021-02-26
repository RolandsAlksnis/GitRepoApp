//
//  ViewController.swift
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signInUsernameField: UITextField!
    @IBOutlet weak var signInPasswordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signInButton(_ sender: UIButton) {
        saveUsername()
        if isUsernameSaved() {
            self.dismiss(animated: true, completion: nil)
        } else {
            print("Error: username was not properly saved")
        }
    }
    
    var userInfo:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInUsernameField.text = ""
     //   signInPasswordField.text = ""                 // This would be needed if there were a password
        signInUsernameField.delegate = self            // Self in this case = loginviewcontroller
     //   signInPasswordField.delegate = self
        if(signInUsernameField.text!.isEmpty)
        {
            signInButton.isUserInteractionEnabled = false
            signInButton.alpha = 0.5
        }
        
    }
    
    func saveUsername() {
        if let validUsername = signInUsernameField.text {
            if !validUsername.isEmpty {
                UserDefaults.standard.set(validUsername, forKey: "Username")
            } else {
                print("Error: username field empty but button was active")
            }
        } else {
            print("Error: username field empty but button was active")
        }
    }
    
    func isUsernameSaved() -> Bool {
        if UserDefaults.standard.string(forKey: "Username") != nil {
            return true
        } else {
            return false
        }
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {


        let signInUser = (signInUsernameField.text! as NSString).replacingCharacters(in: range, with: string)
        if !signInUser.isEmpty{
            signInButton.isUserInteractionEnabled = true
            signInButton.alpha = 1
        } else {
            signInButton.isUserInteractionEnabled = false
        }

 
        /*
        
         Used if there is a password
         
//        let signInPass = (signInPasswordField.text! as NSString).replacingCharacters(in: range, with: string)
//        if !signInPass.isEmpty{
//            signInButton.isUserInteractionEnabled = true
//            signInButton.alpha = 1
//        } else {
//            signInButton.isUserInteractionEnabled = false
//        }
        
        */
        
        return true
    }

    
    
}



