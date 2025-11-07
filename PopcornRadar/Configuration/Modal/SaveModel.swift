import Foundation

struct SavedMovie: Identifiable, Codable {
    let id: Int
    let title: String
    let posterPath: String?
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
