import UIKit

class MainViewController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var collectionsStack: UIStackView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    let scrollView = UIScrollView()
    
    let networkManager: NetworkManager = NetworkManager()
    var popularMovies: MovieResponse?
    var topRatedMovies: MovieResponse?
    var nowPlayingMovies: MovieResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupLoadingView()
        setupCollectionViews()
        fetchMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewLayouts()
    }
}

// MARK: - Logic

extension MainViewController {
    private func setupCollectionViews() {
        let cellName: String = "MovieCollectionViewCell"
        let cellIdentifier = "MovieCell"
        
        nowPlayingCollectionView.dataSource = self
        popularCollectionView.dataSource = self
        topRatedCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        popularCollectionView.delegate = self
        topRatedCollectionView.delegate = self
        
        nowPlayingCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        popularCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        topRatedCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.addSubview(collectionsStack)
        collectionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionsStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            collectionsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            collectionsStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionsStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionsStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let collectionsStackHeightConstraint = collectionsStack.heightAnchor.constraint(equalToConstant: 0)
        collectionsStackHeightConstraint.priority = .defaultLow
        collectionsStackHeightConstraint.isActive = true
        
        collectionsStack.layoutIfNeeded()
        collectionsStackHeightConstraint.constant = collectionsStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
    private func fetchMovies() {
        showLoadingView()
        
        Task {
            do {
                popularMovies = try await networkManager.getMovies(for: .popular)
                nowPlayingMovies = try await networkManager.getMovies(for: .nowPlaying)
                topRatedMovies = try await networkManager.getMovies(for: .topRated)
                
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
        nowPlayingCollectionView.reloadData()
        popularCollectionView.reloadData()
        topRatedCollectionView.reloadData()
    }
    
    private func currentCollectionView(current collectionView: UICollectionView) -> MovieResponse? {
        if collectionView == popularCollectionView {
            return popularMovies
        } else if collectionView == nowPlayingCollectionView {
            return nowPlayingMovies
        }
        return topRatedMovies
    }
    
    private func updateCollectionViewLayouts() {
        let screenSize = UIScreen.main.bounds.size
        
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
        
        nowPlayingCollectionView.isHidden = true
        popularCollectionView.isHidden = true
        topRatedCollectionView.isHidden = true
    }
    
    private func hideLoadingView() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        
        nowPlayingCollectionView.isHidden = false
        popularCollectionView.isHidden = false
        topRatedCollectionView.isHidden = false
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

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCollectionView(current: collectionView)?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        if let movie = currentCollectionView(current: collectionView)?.results[indexPath.row] {
            cell.configure(with: movie)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = currentCollectionView(current: collectionView)?.results[indexPath.item] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let movieDetailsView = storyboard.instantiateViewController(withIdentifier: "MovieDetailsView") as? MovieDetailsViewController {
                movieDetailsView.movieId = movie.id
                navigationController?.pushViewController(movieDetailsView, animated: true)
            }
        }
    }
    
    
}



