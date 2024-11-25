import Foundation

enum SpotifyAPI {
    case getAvailableGenreSeeds(accessToken: String)
    case getRecommendations(genres: [String], accessToken: String)
    
    var description: String {
        switch self {
        case .getAvailableGenreSeeds: "유효한 장르 시드 검색 불러오기 엔드포인트"
        case .getRecommendations(let genres, _): "[\(genres.joined(separator: ","))] 장르에 대한 추천 음악 불러오기 엔드포인트"
        }
    }
}

extension SpotifyAPI: EndPoint {
    var base: String {
        "https://api.spotify.com"
    }
    
    var path: String {
        switch self {
        case .getAvailableGenreSeeds: "/v1/recommendations/available-genre-seeds"
        case .getRecommendations: "/v1/recommendations"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAvailableGenreSeeds: .get
        case .getRecommendations: .get
        }
    }
    
    var headers: [String: String?]? {
        switch self {
        case .getAvailableGenreSeeds(let accessToken):
            return makeAuthorizationHeader(with: accessToken)
        case .getRecommendations(_, let accessToken):
            return makeAuthorizationHeader(with: accessToken)
        }
    }
    
    var body: Data? {
        switch self {
        case .getAvailableGenreSeeds: nil
        case .getRecommendations: nil
        }
    }
    
    var params: [String: String]? {
        switch self {
        case .getAvailableGenreSeeds:
            return nil
        case .getRecommendations(let genres, _):
            return [
                "limit": "100",
                "market": "KR",
                "seed_genres": genres.joined(separator: ",")
            ]
        }
    }
}

private extension SpotifyAPI {
    func makeAuthorizationHeader(with accessToken: String) -> [String: String] {
        return ["Authorization": "Bearer \(accessToken)"]
    }
}
