import SwiftUI

struct DetailMovieView: View {
    @EnvironmentObject var watchlistVM: WatchlistViewModel
    @StateObject  var viewDetailModel: DetailViewModel
    
    var body: some View {
        ZStack{
            Color.clear.backgroundView().ignoresSafeArea()
            if viewDetailModel.isLoading {
                ProgressView("Завантаження...")
                    .foregroundColor(.white)
                    .scaleEffect(1.2)
            } else if let movie = viewDetailModel.detailMoview {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // POSTER
                        AsyncImage(url: movie.posterURL) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(20)
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(height: 350)
                                .cornerRadius(20)
                        }

                        // TITLE
                        Text(movie.title)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)

                        // RATING + YEAR
                        HStack(spacing: 10) {
                            Label("\(movie.voteAverage, specifier: "%.1f")", systemImage: "star.fill")
                                .foregroundColor(.yellow)

                            if let date = movie.releaseDate {
                                Text("• \(date.prefix(4))")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Button {
                                if let movie = viewDetailModel.detailMoview {
                                    watchlistVM.toggle(movie: movie)
                                }
                            } label: {
                                Label(
                                    watchlistVM.isSaved(movie: viewDetailModel.detailMoview!)
                                    ? "Видалити"
                                    : "Дивитись пізніше",
                                    systemImage: watchlistVM.isSaved(movie: viewDetailModel.detailMoview!)
                                    ? "bookmark.fill"
                                    : "bookmark"
                                )
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)


                        }
                        .font(.headline)

                        // GENRES
                        if let genres = movie.genres {
                            FlowLayout(spacing: 8) {
                                ForEach(genres) { genre in
                                    Text(genre.name)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .background(Color.white.opacity(0.15))
                                        .cornerRadius(12)
                                }
                            }
                        }

                        // DESCRIPTION
                        Text(movie.overview)
                            .foregroundColor(.white)
                            .font(.body)
                            .padding(.top, 6)
                    }
                    .padding()
                }
            }
            else if let error = viewDetailModel.errorMessage {
                Text("⚠️ Помилка: \(error)")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Деталі")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewDetailModel.loadDetailMovie()
        }
    }
}
