import SwiftUI

struct GenreMoviesSelection: View {
    let title: String
    let movies: [Movie]
    
    let onReachEnd: (() -> Void)?
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

           

//                Text(title)
//                    .font(.largeTitle.bold())
//                    .foregroundColor(.white)
//                    .padding(.horizontal)
//                    .padding(.top, 10)

                if isLandscape {

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
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
                                .onAppear {
                                    if movie == movies.last {
                                        onReachEnd?()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                    }

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
                            .padding(.horizontal)
                            .onAppear {
                                if movie == movies.last {
                                    onReachEnd?()
                                }
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }

        
    }
}


