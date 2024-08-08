//
//  ViewController.swift
//  Peek
//
//  Created by mazen eldeeb on 08/08/2024.
//

import UIKit

class ViewController: UIViewController {
    let networkManager: NetworkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            do {
                let movie = try await networkManager.getMovieDetails(of: 533535)
                print(movie.overview)
            } catch {
                print("Failed to get popular movies: \(error)")
            }
        }
    }
    
    
}

