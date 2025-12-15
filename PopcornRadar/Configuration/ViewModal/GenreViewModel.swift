import Foundation
import Combine

@MainActor
final class GenreViewModal:BaseViewModel{
    @Published var genreMovies: [Int: [Movie]] = [:]
    @Published var genres: [Genre] = []
    @Published var currentPage: [Int: Int] = [:]
    @Published var totalPages: [Int: Int] = [:]
    @Published var sortOption: MovieSortOption = .ratingDesc
    @Published private(set) var isLoadingMore: Set<Int> = []

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

//
//    func loadMovies(for genreID: Int) async {
//        let page = currentPage[genreID, default: 1]
//    
//        currentPage[genreID] = page + 1
//        await fetchDataAppendToDict(
//            on: self,
//            loader: {
//                let response = try await self.service.getMoviesByGenre(
//                    genreID: genreID,
//                    page: page
//                )
//                self.totalPages[genreID] = response.totalPages
//                return response.results
//            },
//            key: genreID,
//            in: \.genreMovies
//        )
//    }
    func loadMovies(for genreID: Int) async {
          if isLoadingMore.contains(genreID) { return }
          isLoadingMore.insert(genreID)
          defer { isLoadingMore.remove(genreID) }

          let page = currentPage[genreID, default: 1]
          let total = totalPages[genreID, default: Int.max]
          guard page <= total else { return }

          do {
              let response = try await service.getMoviesByGenre(genreID: genreID, page: page)
              totalPages[genreID] = response.totalPages
              let existingIDs = Set(genreMovies[genreID, default: []].map(\.id))
              let newUnique = response.results.filter { !existingIDs.contains($0.id) }
              genreMovies[genreID, default: []].append(contentsOf: newUnique)
              currentPage[genreID] = page + 1

              print("✅ genre \(genreID) page \(page) / total \(response.totalPages) added \(newUnique.count)")
          } catch {
              print("❌ genre \(genreID) page \(page) error: \(error)")
          }
      }

      func loadMoreIfNeeded(for genreID: Int) async {
          await loadMovies(for: genreID)
      }

    func applySort(for genreID: Int) {
        guard let movies = genreMovies[genreID] else { return }
        genreMovies[genreID] = movies.sorted(by: sortOption)
    }

}
