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
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var profileContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let actor = actor else {
            return
        }
        ageLabel.text = actor.calAge(birthday: actor.birthday) + " years old"
        nameLabel.text = actor.name
        bioLabel.text = actor.biography
        if let profilePath = actor.profilePath {
            TMDB.downloadPosterImage(posterPath: profilePath) { data, error in
                guard let data = data else { return }
                self.profileImage.image = UIImage(data: data)
            }
        }
        profileImage.applyShadowWithCornerRadius(containerView: profileContainerView, cornerRadius: 10)

    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
