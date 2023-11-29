//
//  Switcher.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/25/23.
//

//this helper used to: Switch between rootViewController(loginVC / mainVC)

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC() {
        let status = UserDefaults.standard.bool(forKey: "status")
        let rootVC : UIViewController?
        
        let story = UIStoryboard(name: "Main", bundle: .main)
        print("status of userDefaults= ", status)
        if (status == true) {
            let controller = story.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            rootVC = story.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        } else {
            rootVC = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.windows.first
        appDelegate?.rootViewController = rootVC
        appDelegate?.makeKeyAndVisible()
    }
}
