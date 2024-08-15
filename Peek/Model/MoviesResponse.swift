//
//  MoviesResponse.swift
//  Peek
//
//  Created by mazen eldeeb on 08/08/2024.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    var title: String?
    
    func setTitle(with category: MovieCategory) -> String{
        switch category {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        }
    }
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
