import SwiftUI

struct GenreMoviesView: View {
    let genre: Genre
    @ObservedObject var genreVM: GenreViewModal
    
    var body: some View {
        ZStack {
            if let _ = genreVM.genreMovies[genre.id] {
                    GenreMoviesSelection(
                        title: genre.name,
                        movies: genreVM.sortedMovies(for: genre.id),
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
            .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                ForEach(MovieSortOption.allCases) { option in
                                    Button {
                                        genreVM.sortOption = option
                                    } label: {
                                        HStack {
                                            Text(option.title)
                                            if option == genreVM.sortOption {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.title3)
                            }
                        }
                    }
            .task {
                if genreVM.genreMovies[genre.id] == nil {
                    await genreVM.loadMovies(for: genre.id)
                }
            }
        }
    }
