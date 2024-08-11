import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movieId: Int?
    private var movie: Movie?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
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
        setupUI()
        setupLoadingView()
        fetchMovieDetails()
    }
}

// MARK: - UI Setup

extension MovieDetailsViewController {
    private func setupUI() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        movieImage.layer.cornerRadius = 24
        movieImage.layer.masksToBounds = true
        movieImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        [releaseYear, firstCategory, secondCategory].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        }
    }
    
    private func setupLoadingView() {
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.hidesWhenStopped = true
    }
}

// MARK: - Data Fetching and UI Updates

extension MovieDetailsViewController {
    private func fetchMovieDetails() {
        showLoadingView()
        
        Task {
            do {
                movie = try await networkManager.getMovieDetails(of: movieId!)
                DispatchQueue.main.async {
                    self.updateUI()
                    self.hideLoadingView()
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleFetchError(error)
                    self.hideLoadingView()
                }
            }
        }
    }
    
    private func updateUI() {
        guard let movie = movie else { return }
        
        titleLabel.text = movie.title
        voteAverage.text = movie.getVoteAverage()
        voteCount.text = "(\(movie.voteCount))"
        releaseYear.text = "  \(movie.getReleaseYear())  "
        duration.text = movie.getDuration()
        overview.text = movie.overview
        
        let genres = movie.getGenres()
        firstCategory.text = "  \(genres.firstCategory)  "
        secondCategory.text = "  \(genres.secondCategory)  "
        
        if let posterPath = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
            movieImage.load(url: url)
        }
    }
    
    private func showLoadingView() {
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingView() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    private func handleFetchError(_ error: Error) {
        print("Failed to fetch movie details: \(error.localizedDescription)")
        
        let alertController = UIAlertController(
            title: "Error",
            message: "Failed to load movie details. Please try again later.",
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.fetchMovieDetails()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
