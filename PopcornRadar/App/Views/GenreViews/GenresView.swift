import SwiftUI

struct GenresView: View {
    @StateObject private var genreVM = GenreViewModal()
    @State private var selectedGenre: Genre? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .backgroundView()
                    .ignoresSafeArea()
                if genreVM.isLoading {
                    ProgressView("Завантаження жанрів...")
                        .foregroundColor(.black)
                        .scaleEffect(1.2)
                } else if let error = genreVM.errorMessage {
                    Text("Помилка: \(error)")
                        .foregroundColor(.red)
                } else {
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            Text("Оберіть категорію 🎬")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .padding(.top, 30)
                            FlowLayout(spacing: 23) {
                                ForEach(genreVM.genres) { genre in
                                    NavigationLink(destination: GenreMoviesView(genre: genre, genreVM: genreVM)) {
                                        Text(genre.name)
                                            .font(.headline)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .foregroundColor(.white)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.white.opacity(0.1))
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle("Категорії",)
        .task {
            await genreVM.loadGenres()
        }
    }
}
