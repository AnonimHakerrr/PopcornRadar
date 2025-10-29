import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @StateObject private var genreVM = GenreViewModal()
    var body: some View {
        
        ZStack{
            if viewModel.isLoading {
                ProgressView("Завантаження...")
                    .foregroundColor(.white)
                    .scaleEffect(1.2)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 50))
                    Text(error)
                        .foregroundColor(.white)
                    Button("Повторити") {
                        Task {
                            await viewModel.loadPopularMovies()
                            await viewModel.loadTrendingMovies()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        // 🔥 Секція трендів
                        MovieSection(title: "🔥 В тренді", movies: viewModel.trendingMovies)
                        
                        // ⭐️ Секція популярних
                        MovieSection(title: "⭐️ Популярні", movies: viewModel.popularMovies)
                        
                        
                        ForEach(genreVM.genres.prefix(5)) { genre in
                            if let movies = genreVM.genreMovies[genre.id] {
                                MovieSection(title: genre.name, movies: movies)
                                
                            } else {
                                // Поки жанр не завантажився — показуємо лоадер
                                HStack {
                                    ProgressView()
                                        .tint(.gray)
                                    Text("Завантаження \(genre.name)...")
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // 📚 Заглушки для решти
                        Section {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("❤️ Обране — у розробці")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Text("🔍 Пошук — у розробці")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }.task {
            await viewModel.loadTrendingMovies()
            await viewModel.loadPopularMovies()
            await genreVM.loadGenres()
            for genre in genreVM.genres.prefix(5) {
                await genreVM.loadMovies(for: genre.id)
            }
        }
        .backgroundView()
    }
}

#Preview {
    MoviesView()
}
