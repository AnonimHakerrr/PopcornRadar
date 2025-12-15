import SwiftUI
import Kingfisher

struct GenreMoviesSelection: View {
    let title: String
    let movies: [Movie]
    @State private var scrollPosition: Int?
    let onReachEnd: (() -> Void)?
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    var body: some View {
        Group{
            if isLandscape {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                            NavigationLink {
                                DetailMovieView(viewDetailModel: DetailViewModel(movieID: movie.id))
                            } label: {
                                MovieCell(
                                    movie: movie,
                                    width: 150,
                                    isPortrait: false
                                )
                                
                            }
                            .id(movie.id)
                            .onAppear {
                                if index >= movies.count - 3 {
                                    onReachEnd?()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }.scrollPosition(id: $scrollPosition)
                
                
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                            NavigationLink {
                                DetailMovieView(viewDetailModel: DetailViewModel(movieID: movie.id))
                            } label: {
                                MovieCell(
                                    movie: movie,
                                    width: 250,
                                    isPortrait: true
                                )
                            }
                            .id(movie.id)
                            .padding(.horizontal)
                            .onAppear {
                                if index >= movies.count - 3 {
                                    onReachEnd?()
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }.scrollPosition(id: $scrollPosition)
                
            }
        }
        
        
    }
}
