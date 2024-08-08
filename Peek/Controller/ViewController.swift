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
        
        // Create a Task to run the async method
        Task {
            do {
               let moviesResponse = try await networkManager.getPopularMovies()
            } catch {
                print("Failed to get popular movies: \(error)")
            }
        }
    }
    

}

