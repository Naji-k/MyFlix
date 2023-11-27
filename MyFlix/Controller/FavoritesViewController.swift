//
//  FavoritesViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/1/23.
//

import UIKit

class FavoritesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TMDB.getFavoriteList(completion: handleGetFavList(success:error:))
        TMDB.getFavoriteTVList(completion: handleGetFavList(success:error:))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

    }
    func handleGetFavList(success: Bool, error: Error?) {
        if success {
            self.tableView.reloadData()
        } else {
            print(error?.localizedDescription)
        }
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch(section)
//        {
//        case 0:
            return MovieData.favList.count
//        case 1:
//            return MovieData.favTVList.count
//        default:
//            return MovieData.favTVList.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var item: TVResponse?
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell")!
//        switch (indexPath.section) {
//        case 0:
//             item = MovieData.favList[indexPath.row]
//        case 1:
//             item = MovieData.favTVList[indexPath.row]
//        default:
//             item = MovieData.favTVList[indexPath.row]
//        }

//        item = MovieData.favTVList[indexPath.row]
        let item = MovieData.favList[indexPath.row]
        let placeHolder = UIImage(named: "PosterPlaceholder")
        cell.textLabel?.text = item.original_title
        cell.imageView?.image = placeHolder
        if let posterPath = item.posterPath {
            TMDB.downloadPosterImage(posterPath: posterPath) { data, error in
                guard let data = data else { return }
                cell.imageView?.image = UIImage(data: data)
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = MovieData.favList[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.movie = movie
        TMDB.getMovieCredits(movieID: movie.idString) { data, error in
            guard let data = data else {
                print(error)
                return
            }
            DispatchQueue.main.async {
                vc.actorList = data.cast
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
