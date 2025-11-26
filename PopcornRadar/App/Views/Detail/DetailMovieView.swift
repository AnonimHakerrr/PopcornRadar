import SwiftUI
struct DetailMovieView: View {
    @EnvironmentObject var watchlistVM: WatchlistViewModel
    @StateObject var viewDetailModel: DetailViewModel
    @State private var isSharePresented = false
    
    @State private var posterImage: UIImage?

    private var shareItems: [Any] {
        posterImage.map { [$0] } ?? []
    }

   
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            
            ZStack {
                Color.clear.backgroundView().ignoresSafeArea()
                
                if viewDetailModel.isLoading {
                    ProgressView("Завантаження...")
                }
                else if let movie = viewDetailModel.detailMoview {
                    
                    ScrollView {
                        if isLandscape {
                            HStack(alignment: .top, spacing: 20) {
                                
                                // Постер зліва
                                AsyncImage(url: movie.posterURL) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: geo.size.width * 0.35)
                                        .cornerRadius(20)
                                } placeholder: {
                                    Rectangle()
                                        .foregroundColor(.gray.opacity(0.3))
                                        .frame(width: geo.size.width * 0.35, height: 250)
                                }
                                
                                // Контент справа
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    Text(movie.title)
                                        .font(.largeTitle.bold())
                                        .foregroundColor(.white)
                                    
                                    HStack(spacing: 10) {
                                        Label("\(movie.voteAverage, specifier: "%.1f")", systemImage: "star.fill")
                                            .foregroundColor(.yellow)
                                        
                                        if let date = movie.releaseDate {
                                            Text("• \(date.prefix(4))")
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        
                                        Button {
                                            watchlistVM.toggle(movie: movie)
                                        } label: {
                                            Label(
                                                watchlistVM.isSaved(movie: movie) ? "Видалити" : "Дивитись пізніше",
                                                systemImage: watchlistVM.isSaved(movie: movie) ? "trash.fill" : "bookmark"
                                            )
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(watchlistVM.isSaved(movie: viewDetailModel.detailMoview!) ? .red : .orange)
                                        
                                    }
                                    
                                    if let genres = movie.genres {
                                        FlowLayout(spacing: 8) {
                                            ForEach(genres) { genre in
                                                Text(genre.name)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 6)
                                                    .background(Color.white.opacity(0.15))
                                                    .foregroundColor(.white)
                                                    .cornerRadius(12)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                    
                                    Text(movie.overview)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                        }
                        else {
                            VStack(alignment: .leading, spacing: 16) {
                                
                                AsyncImage(url: movie.posterURL) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .cornerRadius(20)
                                } placeholder: {
                                    Rectangle()
                                        .foregroundColor(.gray.opacity(0.3))
                                        .frame(height: 250)
                                }
                                
                                Text(movie.title)
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 10) {
                                    Label("\(movie.voteAverage, specifier: "%.1f")", systemImage: "star.fill")
                                        .foregroundColor(.yellow)
                                    
                                    if let date = movie.releaseDate {
                                        Text("• \(date.prefix(4))")
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    Button {
                                        watchlistVM.toggle(movie: movie)
                                    } label: {
                                        Label(
                                            watchlistVM.isSaved(movie: movie) ? "Видалити" : "Дивитись пізніше",
                                            systemImage: watchlistVM.isSaved(movie: movie) ? "trash.fill" : "bookmark"
                                        )
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(watchlistVM.isSaved(movie: viewDetailModel.detailMoview!) ? .red : .orange)
                                }
                                
                                if let genres = movie.genres {
                                    FlowLayout(spacing: 8) {
                                        ForEach(genres) { genre in
                                            Text(genre.name)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.white.opacity(0.15))
                                                .foregroundColor(.white)
                                                .cornerRadius(12)
                                                .font(.caption)
                                        }
                                    }
                                }
                                
                                Text(movie.overview)
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .navigationTitle("Деталі")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if viewDetailModel.detailMoview != nil {
                        isSharePresented = true
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $isSharePresented) {
            ActivityView(activityItems: shareItems)
        }
        .task {
            await viewDetailModel.loadDetailMovie()
            if let url = viewDetailModel.detailMoview?.posterURL {
                    if let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        posterImage = image
                    }
                }
        }
    }
}
