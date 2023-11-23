//
//  DetailViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/11/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: MovieResponse?
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else {
            print("no movie")
            return
        }
        if let image = movie.poster_path {
            TMDB.downloadPosterImage(posterPath: image) { data, error in
                guard let data = data else { print("error image detailVC"); return }
                self.imageView.image = UIImage(data: data)
            }
        }
        if let cover =  movie.backdropPath {
            TMDB.downloadPosterImage(posterPath: cover) { data, error in
                guard let data = data else {
                    print("error with cover")
                    return}
                self.coverImage.image = UIImage(data: data)
            }
        }
        
        titleLabel.text = movie.title + " (" + movie.releaseYear + ")"
        descLabel.text = movie.overview
        rate.text = "\(String(format: "%.1f", movie.vote_average))"
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 500)
    }
    


}



