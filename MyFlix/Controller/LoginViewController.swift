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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        activityIndicator.alpha = 0
        
    }

    @IBAction func loginTappedBtn(_ sender: Any) {
        handleLogin()
    }
    
    fileprivate func handleLogin(){
        UserDefaults.standard.set(true, forKey: "status")
        
    }
}
