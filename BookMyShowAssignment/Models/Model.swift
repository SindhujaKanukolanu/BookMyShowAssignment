//
//  Model.swift
//  BookMyShowAssignment
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 01/06/21.
//

import Foundation

struct Model: Codable{
        
    let dates: Dates
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey, Hashable {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable , Hashable{
    let maximum, minimum: String
}

// MARK: - Result
struct Result: Codable,Hashable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey, Hashable {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case ko = "ko"
}
