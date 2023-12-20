
//  WatchlistViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/1/23.
//

import UIKit

class WatchlistViewController: UIViewController {
    
    var mediaType: Category = .movie
    
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
    
    
}
