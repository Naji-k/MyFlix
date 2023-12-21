//
//  DetailViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/11/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: MultiTypeMediaResponse?
    var actorList: [Cast] = []
    var mediaType: mediaCategory = .movie
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var favBtn: UIBarButtonItem!
    var watchBtn: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isFavorite: Bool {
        switch(mediaType) {
        case.movie:
            return MovieData.favList.contains{$0.id == movie?.id}
        case.tv :
            return MovieData.favTVList.contains{$0.id == movie?.id}
        case .person:
            return false
        }
    }
    var isWatchList: Bool {
        switch(mediaType) {
        case.movie:
            return MovieData.movieWatchList.contains{$0.id == movie?.id}
        case.tv :
            return MovieData.tvWatchList.contains{$0.id == movie?.id}
        case .person:
            return false
        }
    }
    
    private func setupView() {
        self.navigationItem.title = mediaType.stringValue.uppercased()
        //setup Bar Buttons
        favBtn = UIBarButtonItem(image: UIImage(systemName: "heart.fill") , style: .done, target: self, action: #selector(addToFav))
        watchBtn = UIBarButtonItem(image: UIImage(systemName: "bookmark.circle.fill"), style: .done, target: self, action: #selector(addToWatch))

        self.navigationItem.title = mediaType.stringValue.uppercased()
        self.navigationItem.rightBarButtonItems = [favBtn, watchBtn]

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadMovieDetails()
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    private func loadMovieDetails() {
        guard let movie = movie else {
            presentErrorAlert(message: "No movie details available.")
            self.dismiss(animated: true)
            return
        }
        //update ViewControllerUI
        titleLabel.text = ((movie.title ?? movie.name) ?? "") + " (" + (movie.releaseYear ) + ")"
        descLabel.text = movie.overview
        rate.text = "\(String(format: "%.1f", movie.voteAverage ?? movie.popularity))"
        toggleListButton(favBtn, enabled: isFavorite, type: .favorite)
        toggleListButton(watchBtn, enabled: isWatchList, type: .watch)
        
        //fetching mediaCredits(actors)
        fetchMediaCredits(mediaType: mediaType.stringValue, id: movie.idString)
        //downloadingImages
        downloadCoverProfileImages(movie)
        
    }
    
    private func fetchMediaCredits(mediaType: String, id: String) {
        TMDB.getMediaCredits(mediaType: mediaType, mediaID: id) { data, error in
            guard let data = data else {
                self.presentErrorAlert(message: (error?.localizedDescription ?? "error getting media credits"))
                return
            }
            self.actorList = data.cast
        }
    }
    
    private func downloadCoverProfileImages(_ movie: MultiTypeMediaResponse) {
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
    }
    //MARK: - BarButtons Methods
    @objc func addToFav (sender: UIBarButtonItem) {
        TMDB.markFavorite(listType: ListType.favorite, mediaType: mediaType.stringValue, mediaID: movie!.id, favorite: !isFavorite, watch: nil, completion: handleFavoriteListResponse(success:error:type:))
    }
    @objc func addToWatch(sender: UIBarButtonItem) {
        TMDB.markFavorite(listType: ListType.watch, mediaType: mediaType.stringValue, mediaID: movie!.id, favorite: nil, watch: !isWatchList, completion: handleFavoriteListResponse(success:error:type:))
    }
    
    func handleFavoriteListResponse(success: Bool, error: Error?, type: ListType) {
        guard success else {
            print(error?.localizedDescription ?? "An error occurred.")
            return
        }

        guard let movie = movie else {
            print("No movie or mediaType information available.")
            return
        }
        switch (self.mediaType, type) {
        case (.movie, .favorite):
            updateFavoriteList(&MovieData.favList, with: movie, isFavorite: isFavorite)
        case (.tv, .favorite):
            updateFavoriteList(&MovieData.favTVList, with: movie, isFavorite: isFavorite)
        case (.movie, .watch):
            updateFavoriteList(&MovieData.movieWatchList, with: movie, isFavorite: isWatchList)
        case (.tv, .watch):
            updateFavoriteList(&MovieData.tvWatchList, with: movie, isFavorite: isWatchList)
        case (.person, .watch):
            break
        case (.person, .favorite):
            break
        }
        toggleListButton(favBtn, enabled: isFavorite, type: .favorite)
        toggleListButton(watchBtn, enabled: isWatchList, type: .watch)
    }

    private func updateFavoriteList(_ list: inout [MultiTypeMediaResponse], with movie: MultiTypeMediaResponse, isFavorite: Bool) {
        if isFavorite {
            if let index = list.firstIndex(where: { $0.id == movie.id }) {
                list.remove(at: index)
            }
        } else {
            if !list.contains(where: { $0.id == movie.id }) {
                list.append(movie)
            }
        }
    }
    
    //to toggle the button(if it is in fav list or not) fill color
    func toggleListButton(_ button: UIBarButtonItem, enabled: Bool, type: ListType) {
        switch type {
        case .favorite:
            button.tintColor = enabled ? .red : .gray
        case .watch:
            button.tintColor = enabled ? UIColor(named: "TintGreen") : .gray
        }
    }
}
// MARK: - CollectionViewController Delegate
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
                return
            }
            DispatchQueue.main.async {
                vc.actor = data
            }
            self.navigationController?.present(vc, animated: true)
        }
        
    }

}



