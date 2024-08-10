//
//  MovieDetailsViewController.swift
//  Peek
//
//  Created by mazen eldeeb on 09/08/2024.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movieId: Int?
    var movie: Movie?
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var secondCategory: UILabel!
    @IBOutlet weak var firstCategory: UILabel!
    
    let networkManager: NetworkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        movieImage?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        movieImage?.layer.cornerRadius = 24
        releaseYear.layer.cornerRadius = 10
        firstCategory.layer.cornerRadius = 10
        secondCategory.layer.cornerRadius = 10
        releaseYear.layer.masksToBounds = true
        firstCategory.layer.masksToBounds = true
        secondCategory.layer.masksToBounds = true
        
        Task {
            do {
                movie = try await networkManager.getMovieDetails(of: movieId!)
                DispatchQueue.main.async {
                    guard let movie = self.movie else { return }
                    
                    self.titleLabel.text = movie.title
                    self.voteAverage.text = movie.getVoteAverage()
                    self.voteCount.text = "(\(movie.voteCount))"
                    self.releaseYear.text = "  \(movie.getReleaseYear())  "
                    self.duration.text = movie.getDuration()
                    self.overview.text = movie.overview
                    let genres = movie.getGenres()
                    self.firstCategory.text = "  \(genres.firstCategory)  "
                    self.secondCategory.text = "  \(genres.secondCategory)  "
                    
                    if let posterPath = movie.posterPath {
                        let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
                        self.movieImage.load(url: url)
                    } else {
                        self.movieImage.image = UIImage(named: "prototype")
                    }
                }
                
            } catch {
                print("Failed to fetch movie details: \(error)")
            }
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
