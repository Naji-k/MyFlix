//
//  DetailViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/11/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: MovieResponse?
    var actorList: [Cast] = []
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
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

//        scrollView.isScrollEnabled = true
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 500)
        
        print("ActorListCount= \(actorList.count)")
        print(actorList.count)
        print("name \(actorList[1].name)")
        
        self.collectionView.reloadData()
        
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actorList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ActorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCollectionViewCell", for: indexPath) as! ActorCollectionViewCell
        let actor = actorList[indexPath.row]
        let placeHolder = UIImage(named: "PosterPlaceholder")

        cell.actorNameLabel.text = actor.name
        cell.imageView?.image = placeHolder

        cell.imageView.circleImage()
        if let posterPath = actor.profilePath {
            TMDB.downloadPosterImage(posterPath: posterPath) { data, error in
                guard let data = data else { return }
                cell.imageView?.image = UIImage(data: data)
                cell.setNeedsLayout()
            }
        }
        
        return cell
    }
    
    //Dynamic layout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = (collectionView.frame.width - 36) / 3.0
//        let itemHeight = itemWidth
//        let size = CGSize(width: itemWidth, height: itemHeight)
//        return size
//    }

}



