//
//  SearchViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/25/23.
//

import UIKit

class SearchViewController: UIViewController {

    var resultMovie = [MultiTypeMediaResponse]()
    var mediaType: Category = .tv
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentSearchTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    // so now each time when you add new character to the search bar it will  cancel the previous task, and start a new getRequestTask again ex: harry
    // in a low connection it will call getRequestTask for (h, then ha, then har), so it is useful to cancel the old task request , so each time you are updating
    // the search bar it will cancel the last call and recall it again with the last_added_character

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchTask?.cancel()
        currentSearchTask = TMDB.search(type: mediaType.stringValue, query: searchText, completion: { movies, error in
            self.resultMovie = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentSearchTask?.cancel()
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        resultMovie.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = resultMovie[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell?
        cell?.titleLabel.text = movie.title ?? movie.name
        cell?.yearLabel.text = movie.releaseDate
        cell?.rateLabel.text = "\(String(format: "%.1f", movie.voteAverage ?? movie.popularity))"
        cell?.posterImageView.image = UIImage(named: "PosterPlaceholder")
        if let posterPath = movie.posterPath {
            TMDB.downloadPosterImage(posterPath: posterPath) { data, error in
                if let data = data {
                    cell?.imageView?.image = UIImage(data: data)
                    cell?.layoutIfNeeded()
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = resultMovie[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.movie = movie
        vc.mediaType = self.mediaType
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
