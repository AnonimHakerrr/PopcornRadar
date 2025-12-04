import Foundation

struct Movie: Decodable,Identifiable
{
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let voteAverage: Double
    var posterURL: URL? {
            guard let path = posterPath else { return nil }
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
    var isValidForSearchResult: Bool {
            posterURL != nil &&
            voteAverage > 0 &&
            !overview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}
