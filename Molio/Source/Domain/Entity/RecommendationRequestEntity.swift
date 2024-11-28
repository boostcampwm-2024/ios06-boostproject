struct RecommendationRequestEntity {
    var genres: [String]
    
    var genresDescription: String {
        genres.joined(separator: ",")
    }
    
    func toDTO() -> RecommendationsRequestDTO {
        let requestSeedGenres = genresDescription
        
        return RecommendationsRequestDTO(limit: 20, seedGenres: requestSeedGenres)
    }
}
