
//  WatchlistViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/1/23.
//

import UIKit

class WatchlistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TMDB.getWatchList(completion: handleGetWatchList(success:error:))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    func handleGetWatchList(success: Bool, error: Error?)
    {
        if success {
            self.tableView.reloadData()
        } else {
            print(error?.localizedDescription)
        }
    }

}

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieData.watchList.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell")!
        let movie = MovieData.watchList[indexPath.row]
        let placeHolder = UIImage(named: "PosterPlaceholder")
        cell.textLabel?.text = movie.original_title
        cell.imageView?.image = placeHolder
        if let posterPath = movie.poster_path {
            TMDB.downloadPosterImage(posterPath: posterPath) { data, error in
                guard let data = data else { return }
                cell.imageView?.image = UIImage(data: data)
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    
}
