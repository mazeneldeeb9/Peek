import UIKit

class MainViewController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var moviesCategoriesTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    let networkManager: NetworkManager = NetworkManager()
    var moviesCategories = [MovieResponse]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoadingView()
        fetchMovies()
    }
}


// MARK: Setup Tableview

extension MainViewController {
    private func setupTableView() {
        moviesCategoriesTableView.delegate = self
        moviesCategoriesTableView.dataSource = self
        
        moviesCategoriesTableView.register(MoviesTableViewCell.nib(), forCellReuseIdentifier: MoviesTableViewCell.identifier)
    }
}

// MARK: Update UI

extension MainViewController {
    private func updateUI() {
        moviesCategoriesTableView.reloadData()
    }
}


// MARK: Fetch Data

extension MainViewController {
    private func fetchMovies() {
        showLoadingView()
        
        Task {
            do {
                
                for category in MovieCategory.allCases {
                    var response: MovieResponse = try await networkManager.getMovies(for: category)
                    response.title = response.setTitle(with: category)
                    moviesCategories.append(response)
                }
                
                
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
    
    private func handleFetchError(_ error: Error) {
        print("Failed to fetch movies: \(error.localizedDescription)")
        
        let alertController = UIAlertController(
            title: "Error",
            message: "Failed to load movies. Please try again later.",
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.fetchMovies()  // Retry fetching movies
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - LoadingView

extension MainViewController {
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
    
    private func showLoadingView() {
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        moviesCategoriesTableView.isHidden = true
        
    }
    
    private func hideLoadingView() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        
        moviesCategoriesTableView.isHidden = false
    }
    
    
}







// MARK: Tableview Methods

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesCategoriesTableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.identifier, for: indexPath) as! MoviesTableViewCell
        cell.moviesCategory = moviesCategories[indexPath.row]
        cell.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    
}


// MARK: Navigation Delegate

extension MainViewController: MoviesTableViewCellDelegate {
    func didSelectMovie(_ movie: Movie) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailsView = storyboard.instantiateViewController(withIdentifier: "MovieDetailsView") as? MovieDetailsViewController {
            movieDetailsView.movieId = movie.id
            navigationController?.pushViewController(movieDetailsView, animated: true)
        }
    }
    
    
}
