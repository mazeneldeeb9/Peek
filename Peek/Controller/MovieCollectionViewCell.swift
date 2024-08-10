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
    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var voteAverage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 24
        bottomView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bottomView.layer.cornerRadius = 24
    }
    
    func configure(with movie: Movie) {
        movieTitle.text = movie.title
        voteAverage.text = movie.getVoteAverage()
        if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            movieImage.load(url: url)
        } else {
            movieImage.image = UIImage(named: "prototype")
        }
    }
}
