import SwiftUI

struct GenreMoviesSelection: View {
    let title: String
    let movies: [Movie]
    @State private var scrollPosition: Int?
    let onReachEnd: (() -> Void)?
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            
            if isLandscape {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(movies) { movie in
                            NavigationLink {
                                DetailMovieView(viewDetailModel: DetailViewModel(movieID: movie.id))
                            } label: {
                                MovieCell(
                                    movie: movie,
                                    width: geo.size.height * 0.55,
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
