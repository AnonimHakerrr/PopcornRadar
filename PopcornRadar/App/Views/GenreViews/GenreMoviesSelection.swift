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
                        ForEach(movies) { movie in
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
                                if movie == movies.last {
                                    onReachEnd?()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .scrollTargetLayout()
                }.scrollPosition(id: $scrollPosition)
                
                
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        ForEach(movies) { movie in
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
                                if movie == movies.last {
                                    onReachEnd?()
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.bottom, 30)
                }.scrollPosition(id: $scrollPosition)
                
            }
        }
        
        
    }
}
