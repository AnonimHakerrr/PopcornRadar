import Foundation
import Combine

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published var popularMovies: [Movie] = []
    @Published var trendingMovies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service: MovieService
    
    init(service: MovieService = .shared) {
        self.service = service
    }
    
    func loadPopularMovies() async {
        await fetchData(
            loader: { try await self.service.getPopularMovies(page: 1) },
            assignTo: \.popularMovies
        )
    }
    
    func loadTrendingMovies() async {
        await fetchData(
            loader: { try await self.service.getTrending(timeWindow: "day") },
            assignTo: \.trendingMovies
        )
    }
    
    private func fetchData(
            loader: @escaping () async throws -> MovieResponse,
            assignTo keyPath: ReferenceWritableKeyPath<MoviesViewModel, [Movie]>
        ) async {
            isLoading = true
            errorMessage = nil

            do {
                let response = try await loader()
                self[keyPath: keyPath] = response.results
            } catch {
                errorMessage = "Помилка: \(error.localizedDescription)"
            }

            isLoading = false
        }
}
