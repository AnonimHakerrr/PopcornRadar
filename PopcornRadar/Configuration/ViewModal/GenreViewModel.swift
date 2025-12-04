import Foundation
import Combine

@MainActor
final class GenreViewModal:BaseViewModel{
    @Published var genreMovies: [Int: [Movie]] = [:]
    @Published var genres: [Genre] = []
    @Published var currentPage: [Int: Int] = [:]
    @Published var totalPages: [Int: Int] = [:]
    @Published var sortOption: MovieSortOption = .ratingDesc

    private let service: MovieService
    
    init(service: MovieService? = nil) {
        self.service = service ?? MovieService.shared
    }
    
    func loadGenres() async {
        await fetchData(
            on: self,
            loader: { try await self.service.getGenres().genres },
            assignTo: \.genres)
    }


    func loadMovies(for genreID: Int) async {
        let page = currentPage[genreID, default: 1]

        await fetchDataAppendToDict(
            on: self,
            loader: {
                let response = try await self.service.getMoviesByGenre(
                    genreID: genreID,
                    page: page
                )
                self.totalPages[genreID] = response.totalPages
                return response.results
            },
            key: genreID,
            in: \.genreMovies
        )

        currentPage[genreID] = page + 1
    }
    func loadMoreIfNeeded(for genreID: Int) async {
        let page = currentPage[genreID, default: 1]
        let total = totalPages[genreID, default: 1]

        if page <= total {
            await loadMovies(for: genreID)
        }
    }
    
    func sortedMovies(for genreID: Int) -> [Movie] {
          guard let movies = genreMovies[genreID] else { return [] }
          return movies.sorted(by: sortOption)   
      }
}
