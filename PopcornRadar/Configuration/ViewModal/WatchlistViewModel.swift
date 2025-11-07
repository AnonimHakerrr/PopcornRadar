import Foundation
import Combine

final class WatchlistViewModel: BaseViewModel {
    @Published var watchlist: [SavedMovie] = []
    private let key = "watchlist_key"
    
    override init() {
        super.init()

        loadWitchlist()
    }
    
    func saveWatchlist(){
        if let encoded = try? JSONEncoder().encode(watchlist) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func loadWitchlist(){
        if let savedWatchlist = UserDefaults.standard.data(forKey: key),
           let decodedWatchlist = try? JSONDecoder().decode([SavedMovie].self, from: savedWatchlist)
        {
            watchlist = decodedWatchlist
        }
    }
    
    func toggle(movie: MovieDetail) {
        if let index = watchlist.firstIndex(where: { $0.id == movie.id }) {
            watchlist.remove(at: index) // remove
        } else {
            let saved = SavedMovie(id: movie.id,
                                   title: movie.title,
                                   posterPath: movie.posterPath ?? movie.posterURL?.path)
            watchlist.append(saved)
            print("list - \(watchlist) \n saved - \(saved.posterURL)")

        }
        saveWatchlist()
    }
    
    func remove(_ saved: SavedMovie) {
        if let index = watchlist.firstIndex(where: { $0.id == saved.id }) {
            watchlist.remove(at: index)
            saveWatchlist()
        }
    }

    
    func isSaved(movie: MovieDetail) -> Bool {
        watchlist.contains(where: { $0.id == movie.id })
    }
    
}
