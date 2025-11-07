import Foundation
import Combine

@MainActor
final class SearchViewModel: BaseViewModel {
    @Published var query: String = ""
    @Published var searchResults: [Movie] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let service: MovieService
    
    init(service:MovieService = .shared){
        self.service = service
        super.init()
        // Автопошук із затримкою (debounce)
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                Task { await self.performSearch() }
            }
            .store(in: &cancellables)
    }
    
    func performSearch() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }
        
        await fetchData(
            on: self,
            loader: { try await self.service.searchMovies(query: trimmed).results },
            assignTo: \.searchResults
        )
    }
}
