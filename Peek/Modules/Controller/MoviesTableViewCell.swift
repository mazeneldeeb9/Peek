

import UIKit

class MoviesTableViewCell: UITableViewCell {
    static let identifier: String = "MoviesCategoryTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MoviesTableViewCell", bundle: nil)
    }
    var title: String?
    weak var delegate: MoviesTableViewCellDelegate?
    var moviesCategory: MovieResponse! {
         didSet {
             moviesCollectionView.reloadData()
             categoryTitle.text = moviesCategory.title
         }
     }
    

    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
        override func awakeFromNib() {
        super.awakeFromNib()
       
        moviesCollectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}

// MARK: UICollectionView methods

extension MoviesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesCategory.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = moviesCategory.results[indexPath.row]
        
        cell.configure(with: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = moviesCategory.results[indexPath.item]
        delegate?.didSelectMovie(movie)
    }
    
    
    
    
}

extension MoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 250
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
}




// MARK: Delegate Protocol
// to handle navigation controller
protocol MoviesTableViewCellDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
}

