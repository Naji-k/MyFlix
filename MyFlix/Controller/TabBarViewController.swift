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
        fetchFavLists()
        loadVCToTabBar()
    }
    
    func fetchFavLists() {
        TMDB.getFavoriteList(mediaType: "movies") { success, error in
            if let error = error {
                self.presentErrorAlert(message: "Can't load movie favorite list \(error.localizedDescription)")
            }
        }
        TMDB.getFavoriteList(mediaType: "tv") { success, error in
            if let error = error {
                self.presentErrorAlert(message: "Can't load TV favorite list \(error.localizedDescription)")
            }
        }
        
    }
    
    func loadVCToTabBar() {
        UITabBar.appearance().tintColor = UIColor(named: "TintGreen")
        let movieVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieMainViewController") as! MovieMainViewController
        movieVC.viewControllerType = .movie
        let tab1 = UINavigationController(rootViewController: movieVC)
        tab1.tabBarItem = UITabBarItem(title: "Movie", image: UIImage(named: "Movie"), tag: 0)

        let tvVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieMainViewController") as! MovieMainViewController
        tvVC.viewControllerType = .tv
        let tab2 = UINavigationController(rootViewController: tvVC)
        tab2.tabBarItem = UITabBarItem(title: "TV", image: UIImage(named: "TV"), tag: 1)

        let moreVC = self.storyboard?.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        let tab3 = UINavigationController(rootViewController: moreVC)
        tab3.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "List"), tag: 2)

        viewControllers = [tab1, tab2, tab3]
        
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
    
}
