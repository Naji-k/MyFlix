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
        TMDB.getFavoriteList(mediaType: "movies") { success, error in
            if let error = error {
                print("cant load movie favorite list ",error.localizedDescription)
            }
        }
        TMDB.getFavoriteList(mediaType: "tv") { success, error in
            if let error = error {
                print("cant load tv favorite list ",error.localizedDescription)
            }
        }
        
        
        let movieVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieMainViewController") as! MovieMainViewController
        movieVC.viewControllerType = .movie
        movieVC.tabBarItem = UITabBarItem(title: "Movie", image: UIImage(named: "List"), tag: 0)
        
        let tvVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieMainViewController") as! MovieMainViewController
        tvVC.viewControllerType = .tv
        tvVC.tabBarItem = UITabBarItem(title: "TV", image: UIImage(named: "Genre"), tag: 1)
        
        let favVC = self.storyboard?.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        favVC.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "List"), tag: 2)
        
        viewControllers = [movieVC, tvVC, favVC]
        
        
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
