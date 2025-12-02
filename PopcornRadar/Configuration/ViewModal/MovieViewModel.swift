import Foundation
import Combine

@MainActor
final class MoviesViewModel: BaseViewModel {
    @Published var popularMovies: [Movie] = []
    @Published var trendingMovies: [Movie] = []
    
    private let service: MovieService
    
    init(service: MovieService? = nil) {
        self.service = service ?? MovieService.shared
    }
    
    func loadPopularMovies() async {
        await fetchData(
            on: self,
            loader: { try await self.service.getPopularMovies(page: 1).results },
            assignTo: \.popularMovies
        )
    }
    
    func loadTrendingMovies() async {
        await fetchData(
            on: self,
            loader: { try await self.service.getTrending(timeWindow:.day).results },
            assignTo: \.trendingMovies
        )
    }
    
}
