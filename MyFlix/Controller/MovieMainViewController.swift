//
//  MovieTableViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/29/23.
//

import UIKit

class MovieMainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchBtn: UIBarButtonItem!
    var viewControllerType: Category = .tv
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "MyFlixLabel")
        let imageView = UIImageView(image: logo)
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let titleViewHeight = navigationController?.navigationBar.frame.height ?? 44
        let logoAspect = logo?.size.width
        imageView.frame = CGRect(x: 0, y: 0, width: CGFloat(logoAspect!), height: titleViewHeight)
        navigationItem.titleView = imageView
 

    
        let appearance = UINavigationBarAppearance()
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem = searchBtn
        
        if let titleView = navigationItem.titleView {
            NSLayoutConstraint.activate([
                titleView.centerXAnchor.constraint(equalTo: titleView.superview!.centerXAnchor),
                titleView.centerYAnchor.constraint(equalTo: titleView.superview!.centerYAnchor)
            ])
        }

        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        navigationController?.navigationBar.tintColor = UIColor(named: "TintGreen")
        navigationController?.navigationBar.standardAppearance = appearance
        
        
        fetchMediaData()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //make the title in the center
        if let titleView = navigationItem.titleView {
            NSLayoutConstraint.activate([
                titleView.centerXAnchor.constraint(equalTo: titleView.superview!.centerXAnchor),
                titleView.centerYAnchor.constraint(equalTo: titleView.superview!.centerYAnchor)
            ])
        }
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        fetchMediaData()
        self.refreshControl.endRefreshing()
    }
    
    func fetchMediaData() {
        let queue = DispatchQueue(label: "com.MyFlix.moviedata", attributes: .concurrent)
        let group = DispatchGroup()
        var dataTargets: [(MultiTypeMediaListResponse) -> Void]
        var sorts = [TMDB.MovieSortedBy]()
        switch viewControllerType {
        case .movie:
            sorts = [TMDB.MovieSortedBy.nowPlaying, .topRated, .popular]
            dataTargets = [
                { MovieData.movieNowPlaying = $0.results },
                { MovieData.movieTopRated = $0.results },
                { MovieData.movieMostPopular = $0.results }
            ]
        case .tv:
            sorts = [TMDB.MovieSortedBy.onTheAir, .topRated, .popular]
            dataTargets = [
                { MovieData.TVOnTheAir = $0.results },
                { MovieData.TVTopRated = $0.results },
                { MovieData.TVPopular = $0.results }
            ]
        case .person:
            return
        }
        
        for (sort, target) in zip(sorts, dataTargets) {
            group.enter()
            
            queue.async {
                TMDB.getMediaMain(mediaType: self.viewControllerType.stringValue ,sortedBy: sort.stringValue) { data, error in
                    defer { group.leave() }
                    
                    if let data = data {
                        target(data)
                    } else if let error = error {
                        self.presentErrorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
    @objc func search (sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.mediaType = self.viewControllerType
        vc.title = self.viewControllerType.stringValue.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MovieMainViewController: UITableViewDelegate, UITableViewDataSource, MovieCollectionViewDelegate {
    func didSelectItem(item: MultiTypeMediaResponse) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.movie = item
        vc.mediaType = viewControllerType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MovieTableViewCell {
            cell.collectionView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.delegate = self
        switch (indexPath.section, viewControllerType) {
        case (0, .movie):
            cell.viewControllerType = .movie
            cell.label.text = "Now Playing"
            cell.movies = MovieData.movieNowPlaying
        case (1, .movie):
            cell.viewControllerType = .movie
            cell.label.text = "Top Rated"
            cell.movies = MovieData.movieTopRated
        case (2, .movie):
            cell.viewControllerType = .movie
            cell.label.text = "Most Popular"
            cell.movies = MovieData.movieMostPopular
            
        case (0, .tv):
            cell.viewControllerType = .tv
            cell.label.text = "TV On The Air"
            cell.movies = MovieData.TVOnTheAir
        case (1,.tv):
            cell.viewControllerType = .tv
            cell.label.text = "TV Top Rated"
            cell.movies = MovieData.TVTopRated
        case (2, .tv):
            cell.viewControllerType = .tv
            cell.label.text = "TV Most Popular"
            cell.movies = MovieData.TVPopular
        default:
            break
        }
        
        return cell
    }
}
