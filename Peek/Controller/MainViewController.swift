//
//  ViewController.swift
//  Peek
//
//  Created by mazen eldeeb on 08/08/2024.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    let networkManager: NetworkManager = NetworkManager()
    var popularMovies: MovieResponse?
    var topRatedMovies: MovieResponse?
    var nowPlayingMovies: MovieResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingCollectionView.dataSource = self
        popularCollectionView.dataSource = self
        topRatedCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        popularCollectionView.delegate = self
        topRatedCollectionView.delegate = self
        
        nowPlayingCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        popularCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        topRatedCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
        Task {
            do {
                popularMovies = try await networkManager.getMovies(for: .popular)
                nowPlayingMovies = try await networkManager.getMovies(for: .nowPlaying)
                topRatedMovies = try await networkManager.getMovies(for: .topRated)
                
                DispatchQueue.main.async {
                    self.nowPlayingCollectionView.reloadData()
                    self.popularCollectionView.reloadData()
                    self.topRatedCollectionView.reloadData()
                }
                viewDidLayoutSubviews() // Ensure layout updates
            } catch {
                print("Failed to fetch movies: \(error)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenSize = UIScreen.main.bounds.size
        
        // Ensure the superview exists
        if let parentHeight = nowPlayingCollectionView.superview?.bounds.height {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: (screenSize.width / 2.3) + 10, height: parentHeight - 55)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
            nowPlayingCollectionView.collectionViewLayout = layout
            popularCollectionView.collectionViewLayout = layout
            topRatedCollectionView.collectionViewLayout = layout
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularCollectionView {
            return popularMovies?.results.count ?? 0
        } else if collectionView == nowPlayingCollectionView {
            return nowPlayingMovies?.results.count ?? 0
        } else if collectionView == topRatedCollectionView {
            return topRatedMovies?.results.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
          
          var movie: Movie?
          if collectionView == popularCollectionView {
              movie = popularMovies?.results[indexPath.item]
          } else if collectionView == nowPlayingCollectionView {
              movie = nowPlayingMovies?.results[indexPath.item]
          } else if collectionView == topRatedCollectionView {
              movie = topRatedMovies?.results[indexPath.item]
          }
          
          if let movie = movie {
              cell.configure(with: movie)
          }
          
          return cell
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movie: Movie?
        if collectionView == popularCollectionView {
            movie = popularMovies?.results[indexPath.item]
        } else if collectionView == nowPlayingCollectionView {
            movie = nowPlayingMovies?.results[indexPath.item]
        } else if collectionView == topRatedCollectionView {
            movie = topRatedMovies?.results[indexPath.item]
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailsView = storyboard.instantiateViewController(withIdentifier: "MovieDetailsView") as! MovieDetailsViewController
        movieDetailsView.movieId = movie?.id
        navigationController?.pushViewController(movieDetailsView, animated: true)
    }
}
