//
//  ViewController-Helper.swift
//  MyFlix
//
//  Created by Naji Kanounji on 12/20/23.
//

import UIKit


import UIKit

extension UIViewController {
    
    //present alert message (for error with ok button)
    func presentErrorAlert(message: String, title: String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(dismissAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    //alert vc with two options (YES/NO) each option could have a handler
    func askQuestionAlert(title: String , message: String, yesHandler: (() -> Void)? = nil, noHandler: (() -> Void)? = nil) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           
           let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
               yesHandler?()
           }
           
           let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
               noHandler?()
           }
           
           alertController.addAction(yesAction)
           alertController.addAction(noAction)
           
           DispatchQueue.main.async {
               self.present(alertController, animated: true)
           }
       }
    
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        navigationController?.navigationBar.tintColor = UIColor(named: "TintGreen")
        navigationController?.navigationBar.standardAppearance = appearance
    }
}
