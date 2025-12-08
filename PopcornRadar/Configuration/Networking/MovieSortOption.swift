import Foundation

enum MovieSortOption: String, CaseIterable, Identifiable {
    case ratingDesc
    case releaseDateDesc
    case titleAsc
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .ratingDesc:
            return "За рейтингом"
        case .releaseDateDesc:
            return "За датою виходу"
        case .titleAsc:
            return "За назвою"
        }
    }
}


extension Array where Element == Movie {
    func sorted(by option: MovieSortOption) -> [Movie] {
        switch option {
        case .ratingDesc:
            return self.sorted { $0.voteAverage > $1.voteAverage }
        case .releaseDateDesc:
            return self.sorted { $0.releaseDate > $1.releaseDate }
        case .titleAsc:
            return self.sorted { $0.title < $1.title }
        }
    }
}
