import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @StateObject private var genreVM = GenreViewModal()
    var body: some View {
        NavigationStack{
            
            ZStack{
                Color.clear.backgroundView().ignoresSafeArea()
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
                            
                            MovieSection(title: "🔥 В тренді", movies: viewModel.trendingMovies)
                            
                            MovieSection(title: "⭐️ Популярні", movies: viewModel.popularMovies)
                            
                            
                            ForEach(genreVM.genres.prefix(5)) { genre in
                                if let movies = genreVM.genreMovies[genre.id] {
                                    MovieSection(title: genre.name, movies: movies){
                                        GenreMoviesView(genre: genre,genreVM: genreVM)}
                                } else {
                                    HStack {
                                        ProgressView()
                                            .tint(.gray)
                                        Text("Завантаження \(genre.name)...")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            
                            
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Фільми")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .onAppear {
            Task {
                if viewModel.trendingMovies.isEmpty {
                    await viewModel.loadTrendingMovies()
                }
                if viewModel.popularMovies.isEmpty {
                    await viewModel.loadPopularMovies()
                }
                if genreVM.genres.isEmpty {
                    await genreVM.loadGenres()
                    for genre in genreVM.genres.prefix(5) {
                        if genreVM.genreMovies[genre.id] == nil {
                            await genreVM.loadMovies(for: genre.id)
                        }
                    }
                }
            }
        }
        
        
        
    }
}

