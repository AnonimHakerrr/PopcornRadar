import Foundation
import Combine

@MainActor
final class GenreViewModal:BaseViewModel{
    @Published var genreMovies: [Int: [Movie]] = [:]
    @Published var genres: [Genre] = []
    
    private let service: MovieService
    
    init(service: MovieService = .shared) {
        self.service = service
    }
    
    func loadGenres() async {
        await fetchData(
            on: self,
            loader: { try await self.service.getGenres().genres },
            assignTo: \.genres)
        print("✅ Genres loaded: \(genres)")
    }
    
    func loadMovies(for genreID: Int) async {
        print("🔄 Loading movies for genre \(genreID)")
        await fetchData(
            on: self,
            loader: { try await self.service.getMoviesByGenre(genreID: genreID).results},
            assignToDict: genreID,
            in: \.genreMovies
        )
        print("✅ Loaded \(genreMovies[genreID]?.count ?? 0) movies for genre \(genreID)")
    }
}
