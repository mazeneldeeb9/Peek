//
//  NetworkManager.swift
//  Peek
//
//  Created by mazen eldeeb on 08/08/2024.
//

import Foundation


struct NetworkManager {
    
    func getPopularMovies() async throws -> MovieResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular") else {
            throw NetworkError.badUrl
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0ODhjZmIxYzUzMjMzYTczYWY0ZjI0Y2JhMmFiNGU3MiIsIm5iZiI6MTcyMzA0NzA3Ni44ODY1ODIsInN1YiI6IjY2YjM2NTdmOTNlZTc4MTk4YTdiOTA1NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.evCPiBsuvwVuRO53d6fAVq0Powd5JVSevI7SkMQrzso"
        ]
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.requestFailed(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            
            let decoder = JSONDecoder()
            do {
                let moviesResponse = try decoder.decode(MovieResponse.self, from: data)
                return moviesResponse
            } catch {
                throw NetworkError.decodingFailed
            }
            
        } catch {
            print("Network request failed with error: \(error)")
            throw error
        }
    }
    
}


enum NetworkError: Error {
    case badUrl
    case requestFailed(statusCode: Int)
    case decodingFailed
    
    
}
