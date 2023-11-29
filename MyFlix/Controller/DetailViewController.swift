//
//  DetailViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/11/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: Result?
//    var movie: MovieResponse?
    var actorList: [Cast] = []
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var favBtn: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var isWatchlist: Bool {
//        return MovieModel.watchlist.contains(movie)
//    }
    
    var isFavorite: Bool {
//        return MovieData.favList.contains(movie!)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        guard let movie = movie else {
            print("no movie")
            self.dismiss(animated: true)
            return
        }
        
        TMDB.getMovieCredits(movieID: movie.idString) { data, error in
            guard let data = data else {
                print(error)
                return
            }
            self.actorList = data.cast
        }
            
//        toggleButton(favBtn, enabled: isFavorite)
        if let image = movie.posterPath {
            TMDB.downloadPosterImage(posterPath: image) { data, error in
                guard let data = data else { print("error image detailVC"); return }
                self.imageView.image = UIImage(data: data)
            }
        }
        if let cover =  movie.backdropPath {
            TMDB.downloadPosterImage(posterPath: cover) { data, error in
                guard let data = data else {
                    print("error with cover"); return}
                self.coverImage.image = UIImage(data: data)
            }
        }
        
        titleLabel.text = ((movie.title ?? movie.name) ?? "") + " (" + ((movie.releaseDate ?? movie.firstAirDate) ?? "") + ")"
        descLabel.text = movie.overview
        rate.text = ""
        
        favBtn = UIBarButtonItem(image: UIImage(systemName: "heart.fill") , style: .done, target: self, action: #selector(addToFav))
        if (isFavorite) {
            favBtn.tintColor = UIColor.red
        } else {
            favBtn.tintColor = .gray
        }
        navigationItem.title = movie.mediaType
        navigationItem.rightBarButtonItem = favBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    @objc func addToFav (sender: UIBarButtonItem) {
        TMDB.markFavorite(mediaType: "movie", mediaID: movie!.id, favorite: !isFavorite, completion: handleFavoriteListResponse(success:error:))
    }
    
    func handleFavoriteListResponse(success: Bool, error: Error?) {
//        if success {
//            if isFavorite {
//                if let index = MovieData.favList.firstIndex(where: { $0 == movie  }) {
//                    print("index= \(index)")
//                    MovieData.favList.remove(at: index)
//                }
//            } else {
//                MovieData.favList.append(movie!)
//            }
//            toggleButton(favBtn, enabled: isFavorite)
//        }
//        else {
//            print(error)
//        }
    }
    
    //to toggle the button(if it is in fav list or not) fill color
    func toggleButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = .red
        } else {
            button.tintColor = .gray
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ActorDetailViewController") as! ActorDetailViewController
        let actorID = actorList[indexPath.row].idString
        TMDB.getPersonDetails(personID: actorID) { data,error  in
            guard let data = data else {
                print(error)
                return
            }
            DispatchQueue.main.async {
                vc.actor = data
            }
            self.navigationController?.present(vc, animated: true)
        }
        
    }
    
    //Dynamic layout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = (collectionView.frame.width - 36) / 3.0
//        let itemHeight = itemWidth
//        let size = CGSize(width: itemWidth, height: itemHeight)
//        return size
//    }

}



