import Foundation
import Combine
final class DetailViewModel: BaseViewModel {
    @Published var detailMoview: MovieDetail?
    private let movieID: Int
    private let service: MovieService
    
    init(movieID: Int,service: MovieService = .shared ) {
        self.service = service
        self.movieID = movieID
    }
    
    func loadDetailMovie() async {
        await fetchData(
            on: self,
            loader: { try await self.service.getDetails(for: self.movieID)} ,
            assignTo: \.detailMoview )
    }
}
