//
//  MovieTableViewCell.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/29/23.
//  This cell in the MovieTableViewController(mainVC for Movie)

import UIKit

protocol MovieCollectionViewDelegate: AnyObject {
    func didSelectItem(item: MultiTypeMediaResponse)
}

class MovieTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var viewControllerType: Category = .tv
    
    weak var delegate: MovieCollectionViewDelegate?
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [MultiTypeMediaResponse]?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: -CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell {
            
            let item = movies?[indexPath.row]
            
            cell.movieLabel.text = item?.title ?? item?.name
            if let poster = item?.posterPath {
                cell.imageView.downloadImage(urlString: TMDB.Endpoints.posterImageUrl(poster).stringValue)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = movies?[indexPath.row] {
            delegate?.didSelectItem(item: item)
            
        }
    }
    
}
