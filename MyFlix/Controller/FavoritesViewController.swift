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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        //        navigationController?.navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }
    func handleGetFavList(success: Bool, error: Error?) {
        if success {
            self.tableView.reloadData()
        } else {
            self.presentErrorAlert(message: (error?.localizedDescription ?? "error adding to favorite!") as String)
        }
    }
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Movie Favorites"
        case 1:
            return "TV Favorites"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section)
        {
        case 0:
            return MovieData.favList.count
        case 1:
            return MovieData.favTVList.count
        default:
            return MovieData.favList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: MultiTypeMediaResponse?
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell")!
        switch (indexPath.section) {
        case 0:
            item = MovieData.favList[indexPath.row]
        case 1:
            item = MovieData.favTVList[indexPath.row]
        default:
            item = MovieData.favTVList[indexPath.row]
        }
        
        let placeHolder = UIImage(named: "PosterPlaceholder")
        cell.textLabel?.text = item?.title ?? item?.name
        cell.imageView?.image = placeHolder
        if let posterPath = item?.posterPath {
            TMDB.downloadPosterImage(posterPath: posterPath) { data, error in
                guard let data = data else { return }
                cell.imageView?.image = UIImage(data: data)
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: MultiTypeMediaResponse?
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        switch (indexPath.section) {
            
        case 0:
            item = MovieData.favList[indexPath.row]
            vc.mediaType = .movie
        case 1:
            item = MovieData.favTVList[indexPath.row]
            vc.mediaType = .tv
        default:
            return
        }
        
        vc.movie = item
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //here call markFav
            var item: MultiTypeMediaResponse?
            var mediaType: mediaCategory
            switch indexPath.section {
            case 0:
                item = MovieData.favList[indexPath.row]
                mediaType = .movie
            case 1:
                item = MovieData.favTVList[indexPath.row]
                mediaType = .tv
            default:
                return
            }
            guard let unwrappedItem = item else { return }
            //remove item and update tableView
            TMDB.markFavorite(listType: .favorite, mediaType: mediaType.stringValue, mediaID: unwrappedItem.id, favorite: false, watch: nil, completion: { success, error,list  in
                if success {
                    if mediaType == .movie, let index = MovieData.favList.firstIndex(where: { $0.id == item?.id }) {
                        MovieData.favList.remove(at: index)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else if mediaType == .tv, let index = MovieData.favTVList.firstIndex(where: { $0.id == item?.id }) {
                        MovieData.favTVList.remove(at: index)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    print(error?.localizedDescription ?? "failed to mark favorite")
                }
            })
        }
    }
    
}
