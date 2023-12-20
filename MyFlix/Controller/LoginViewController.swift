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
        //here login successfully with SessionID
        if (getKeychain())
        {
            UserDefaults.standard.set(loggedIn, forKey: "status")
        }
        Switcher.updateRootVC()
    }
    
    func handleRequestTokenResponse(success: Bool, error: Error?) {
        if success {
            TMDB.login(userName: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        } else {
            print(error ?? "request token fails")
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            TMDB.createSessionId(completion: handleSessionId(success:error:))
        } else {
//            print("login fails ", error)
            presentErrorAlert(message: "Login fails")
        }
    }
    func handleSessionId(success: Bool, error: Error?) {
        if success {
            print(TMDBClient.Auth.sessionId)
            setKeychain(sessionId: TMDBClient.Auth.sessionId)
            _ = getKeychain()
            handleLogin(loggedIn: true)
            print("login success")
        } else {
            print("SessionID error ")
        }
    }
    
    func getKeychain() -> Bool
    {
        let security = SecureStore.init()
        do {
            let session = try security.getEntry(forKey: "sessionID")
            TMDBClient.Auth.sessionId = session ?? ""
            
        } catch {
            print("error > ", error.localizedDescription)
            return false
        }
        if (TMDBClient.Auth.sessionId.isEmpty == false)
        {
            return true
        }
        return false
    }
    
    func setKeychain(sessionId: String) {
        let security = SecureStore.init()
    
        do {
            try security.set(entry: sessionId, forKey: "sessionID")
    
        } catch {
            print("error > ", error.localizedDescription)
        }
    }
}
