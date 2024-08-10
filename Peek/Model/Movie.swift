import Foundation

struct Movie: Decodable {
    let title: String
    let backdropPath: String
    private let genreIds: [Int]?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let video: Bool
    private let voteAverage: Double
    let voteCount: Int
    var budget: Int?
    private var runtime: Int?
    private var genres: [Genre]?
    var productionCompanies: [ProductionCompany]?

    enum CodingKeys: String, CodingKey {
        case title
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case budget
        case runtime
        case genres
        case productionCompanies = "production_companies"
    }

    func getDuration() -> String {
        guard let runtime = self.runtime else { return "N/A" }
        let hours = runtime / 60
        let mins = runtime % 60
        if hours == 0 {
            return "\(mins)m"
        }
        if mins == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(mins)m"
    }

    func getReleaseYear() -> String {
        return String(releaseDate.prefix(4))
    }
    func getVoteAverage() -> String {
        return String(format: "%.1f", self.voteAverage)
    }

    func getGenres() -> (firstCategory: String, secondCategory: String) {
        let firstGenre = genres?.first?.name ?? "Unknown"
        let secondGenre = genres?.dropFirst().first?.name ?? "Unknown"
        return (firstGenre, secondGenre)
    }
}




struct MovieDetails {
    let runtime: Int
    let genres: [Genre]
    let productionCompanies: [ProductionCompany]
}

// MARK: - Genre Model
struct Genre: Decodable {
    let id: Int
    let name: String
}

// MARK: - ProductionCompany Model
struct ProductionCompany: Decodable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
