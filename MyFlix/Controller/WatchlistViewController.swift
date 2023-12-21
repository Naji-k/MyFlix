
//  WatchlistViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/1/23.
//

import UIKit

class WatchlistViewController: UIViewController {
    
    var mediaType: mediaCategory = .movie
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        switch (mediaType) {
        case.movie:
            TMDB.getWatchList(mediaType: "movies", completion: handleGetWatchList(success:error:))
        case .tv:
            TMDB.getWatchList(mediaType: "tv", completion: handleGetWatchList(success:error:))
        case .person:
            return
        }
        
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
            self.presentErrorAlert(message: "Can't get watch list")
        }
    }
    
}

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(mediaType) {
        case .movie:
            return MovieData.movieWatchList.count
        case .tv:
            return MovieData.tvWatchList.count
        case .person:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: MultiTypeMediaResponse?
        switch(mediaType) {
        case .movie:
            item = MovieData.movieWatchList[indexPath.row]
        case .tv:
            item = MovieData.tvWatchList[indexPath.row]
        case .person:
            item = MovieData.tvWatchList[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell")!
        
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
        
        switch (mediaType) {
        case .movie:
            item = MovieData.movieWatchList[indexPath.row]
        case .tv:
            item = MovieData.tvWatchList[indexPath.row]
        default:
            return
        }
        vc.mediaType = mediaType
        vc.movie = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var item: MultiTypeMediaResponse?
            switch (mediaType) {
            case.movie:
                item = MovieData.movieWatchList[indexPath.row]
            case .tv:
                item = MovieData.tvWatchList[indexPath.row]
            case .person:
                return
            }
            guard let unwrappedItem = item else { return }
            //remove item and update tableView
            TMDB.markFavorite(listType: .watch, mediaType: mediaType.stringValue, mediaID: unwrappedItem.id, favorite: nil, watch: false, completion: { success, error,list  in
                if success {
                    if self.mediaType == .movie, let index = MovieData.movieWatchList.firstIndex(where: { $0.id == item?.id }) {
                        MovieData.movieWatchList.remove(at: index)
                    } else if self.mediaType == .tv, let index = MovieData.tvWatchList.firstIndex(where: { $0.id == item?.id }) {
                        MovieData.tvWatchList.remove(at: index)
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    print(error?.localizedDescription ?? "failed to mark favorite")
                }
            })

        }
    }
}
