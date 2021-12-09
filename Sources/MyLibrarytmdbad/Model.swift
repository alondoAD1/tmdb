import Foundation


struct MovieResult: Codable {
    let results: [Result]
    enum CodingKeys: String, CodingKey { case results }
}

public struct Result: Codable {
    let poster_path: String
    let overview: String
    let release_date: String
    public let id: Int
    let title: String
    let backdrop_path: String
    let video: Bool
    let vote_average: Double
}

struct TVResult: Decodable {
    let results: [Resultseries]
    enum CodingKeys: String, CodingKey { case results }
}

public struct Resultseries: Codable {
    let poster_path: String
    public let id: Int
    let backdrop_path: String
    let vote_average: Double
    let overview: String
    let first_air_date: String
    let name: String
}

struct MovieTrailer: Decodable {
    public let id: Int?
    let results: [MovieTrailerresult]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case results = "results"
    }
}

struct MovieTrailerresult: Codable {
    let key: String?
    let type: String?
    public let id: String?
}


