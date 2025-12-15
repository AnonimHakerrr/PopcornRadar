import SwiftUI

struct GenreMoviesView: View {
    let genre: Genre
    @ObservedObject var genreVM: GenreViewModal
    
    var body: some View {
        ZStack {
            Color.clear.backgroundView()
            if let _ = genreVM.genreMovies[genre.id] {
                GenreMoviesSelection(
                    title: genre.name,
                    movies: genreVM.genreMovies[genre.id] ?? [],
                    onReachEnd: {
                        Task {
                            await genreVM.loadMoreIfNeeded(for: genre.id)
                        }
                    }
                ).onChange(of: genreVM.sortOption) { _ in
                    genreVM.applySort(for: genre.id)
                }

                
            } else if genreVM.isLoading {
                ProgressView("Завантаження \(genre.name)...")
                    .tint(.pink)
            } else {
                Text("Немає фільмів для \(genre.name)")
                    .foregroundColor(.gray)
            }
            
        }
        .navigationTitle(genre.name)
        .navigationBarTitleDisplayMode(.inline)
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
                        .font(.system(size: 17))
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

