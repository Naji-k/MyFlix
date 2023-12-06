//
//  MoreViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 12/5/23.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var viewController: UITableView!
    
    @IBOutlet weak var profileUserNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    let userLists = ["Favorite", "TV Watch List", "Movie Watch List"]
    override func viewDidLoad() {
        super.viewDidLoad()
        TMDB.getAccountInfo(completion: getAccountInfoCompletionHandler(success:error:))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        print("LOG OUT")
    }
    
    func getAccountInfoCompletionHandler(success: Bool, error: Error?) {
        if success {
            self.tableView.reloadData()
            self.profileUserNameLabel.text = TMDBClient.profileInfo?.username ?? TMDBClient.profileInfo?.name
        } else {
            print(error?.localizedDescription)
        }
        
    }

}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = userLists[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        
        cell.textLabel?.text = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = userLists
        var vc : UIViewController?
        switch indexPath.row {
        case 0: //favorites
             vc = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController
            vc?.navigationItem.title = "Favorites List"
        case 1: //tvWatchlist
             let watchListVC = storyboard?.instantiateViewController(withIdentifier: "WatchlistViewController") as?  WatchlistViewController
            watchListVC?.mediaType = .tv
            watchListVC?.navigationItem.title = "TV Watching List"
            vc = watchListVC
        case 2: //MovieWatchlist
            let watchListVC = storyboard?.instantiateViewController(withIdentifier: "WatchlistViewController") as?  WatchlistViewController
            watchListVC?.mediaType = .movie
            watchListVC?.navigationItem.title = "Movie Watching List"
            vc = watchListVC

        default:
            return
        }
        if let viewController = vc {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}