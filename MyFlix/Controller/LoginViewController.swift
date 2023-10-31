//
//  LoginViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/20/23.
//

import UIKit

class LoginViewController: UIViewController {
    

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //hide keyboard using tap gesture
    @IBAction func tap(_ sender: Any) {
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        activityIndicator.alpha = 0
        
    }

    @IBAction func loginTappedBtn(_ sender: Any) {
        TMDB.getRequestToken(completion: handleRequestTokenResponse(success:error:))

    }
    
    fileprivate func handleLogin(loggedIn: Bool){
        UserDefaults.standard.set(loggedIn, forKey: "status")
        Switcher.updateRootVC()
        
    }
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            print(success)
            TMDB.login(userName: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        } else {
            print("request token fails", error)
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            handleLogin(loggedIn: true)
            print("login success")
        } else {
            print("login failsHERE", error)
        }
    }
}
