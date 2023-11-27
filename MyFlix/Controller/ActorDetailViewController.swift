//
//  ActorDetailViewController.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/27/23.
//

import UIKit

class ActorDetailViewController: UIViewController {
    
    var actor: ActorDetailResponse?
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(actor ?? "NO ACTOR")
        nameLabel.text = actor?.name
        bioLabel.text = actor?.biography
        if let profilePath = actor?.profilePath {
            TMDB.downloadPosterImage(posterPath: profilePath) { data, error in
                guard let data = data else { return }
                self.profileImage.image = UIImage(data: data)
            }
        }
    }
    
}
