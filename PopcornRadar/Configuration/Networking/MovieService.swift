import Foundation

final class MovieService
{
    static let shared = MovieService()
    private init(){}
    
    func getPopularMovies(page: Int = 1)async throws -> MovieResponse{
        let endpoint = MovieEndpoint.popular(page: page)
        return try await Networking.shared.request(
            endpoint: endpoint.path,
            queryItems: endpoint.queryItems
        )
    }
    
    func getTrending(timeWindow: String = "day") async throws -> MovieResponse {
        let endpoint = MovieEndpoint.trending(timeWindow: timeWindow)
        return try await Networking.shared.request(
            endpoint: endpoint.path,
            queryItems: endpoint.queryItems
        )
    }
    
    func getDetails(for id: Int) async throws -> MovieDetail {
        let endpoint = MovieEndpoint.details(id: id)
        return try await Networking.shared.request(
            endpoint: endpoint.path,
            queryItems: endpoint.queryItems
        )
    }
    
    func searchMovies(query: String, page: Int = 1) async throws -> MovieResponse {
        let endpoint = MovieEndpoint.search(query: query, page: page)
        return try await Networking.shared.request(
            endpoint: endpoint.path,
            queryItems: endpoint.queryItems
        )
    }
}
