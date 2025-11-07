import SwiftUI

struct GenreMoviesView: View {
    let genre: Genre
    @ObservedObject var genreVM: GenreViewModal
    
    var body: some View {
        ZStack {
            
            if let movies = genreVM.genreMovies[genre.id] {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        GenreMoviesSelection(title: genre.name, movies: movies)
                    }
                    .padding(.top, 10)
                }
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
