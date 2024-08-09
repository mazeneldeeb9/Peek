//
//  ViewController.swift
//  Peek
//
//  Created by mazen eldeeb on 08/08/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    let networkManager: NetworkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        nowPlayingCollectionView.dataSource = self
        popularCollectionView.dataSource = self
        topRatedCollectionView.dataSource = self
            
        nowPlayingCollectionView?.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        popularCollectionView?.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        topRatedCollectionView?.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let screenSize = UIScreen.main.bounds.size

        // Ensure the superview exists
        if let parentHeight = self.nowPlayingCollectionView.superview?.bounds.height {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal

            layout.itemSize = CGSize(width: (screenSize.width / 2.3) + 10, height: parentHeight - 55)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
           layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            // Apply the layout to the collection view
            nowPlayingCollectionView.collectionViewLayout = layout
            popularCollectionView.collectionViewLayout = layout
            topRatedCollectionView.collectionViewLayout = layout
        }
    }
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        return cell
    }
}
