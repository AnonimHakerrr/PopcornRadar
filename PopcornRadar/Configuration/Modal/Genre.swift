import Foundation

struct GenreResponse: Decodable {
    let genres: [Genre]
}
struct Genre: Decodable, Identifiable {
    let id: Int
    let name: String
}
