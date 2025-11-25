import SwiftUI

struct GenreMoviesView: View {
    let genre: Genre
    @ObservedObject var genreVM: GenreViewModal
    
    var body: some View {
        ZStack {
            
            if let movies = genreVM.genreMovies[genre.id] {
                GenreMoviesSelection(
                    title: genre.name,
                    movies: movies,
                    onReachEnd: {
                        Task {
                            await genreVM.loadMoreIfNeeded(for: genre.id)
                        }
                    }
                )
            } else if genreVM.isLoading {
                ProgressView("Завантаження \(genre.name)...")
                    .tint(.pink)
            } else {
                Text("Немає фільмів для \(genre.name)")
                    .foregroundColor(.gray)
            }
        }
        .backgroundView()
        .navigationTitle(genre.name)
        .task {
            if genreVM.genreMovies[genre.id] == nil {
                await genreVM.loadMovies(for: genre.id)
            }
        }
    }
}
