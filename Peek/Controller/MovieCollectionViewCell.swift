//
//  MovieCollectionViewCell.swift
//  Peek
//
//  Created by mazen eldeeb on 09/08/2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    var movie: Movie?
    
    @IBOutlet weak var bottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 24
        bottomView?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bottomView?.layer.cornerRadius = 24
    }

}
