//
//  TabBarViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/31/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        if (!getKeychain())
        {
            UserDefaults.standard.set(false, forKey: "status")
            Switcher.updateRootVC()
        }
        
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
