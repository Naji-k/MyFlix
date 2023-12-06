//
//  MovieCollectionViewCell.swift
//  MyFlix
//
//  Created by Naji Kanounji on 11/29/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieCellContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    var cornerRadius: CGFloat = 8.0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //CornerRadius
        movieCellContainer.layer.cornerRadius = cornerRadius
        movieCellContainer.layer.borderColor = UIColor.black.cgColor
        movieCellContainer.layer.borderWidth = 0.5
        movieCellContainer.layer.masksToBounds = true
        //apply Shadow
        movieCellContainer.layer.shadowColor = UIColor.black.cgColor
        movieCellContainer.layer.shadowOffset = CGSize(width: 1, height: 2)
        movieCellContainer.layer.shadowOpacity = 1
        movieCellContainer.layer.shadowRadius = 8
        movieCellContainer.clipsToBounds = true
        
        movieCellContainer.layer.shadowPath = UIBezierPath(roundedRect: movieCellContainer.bounds, cornerRadius: 8).cgPath
    }
    
}
