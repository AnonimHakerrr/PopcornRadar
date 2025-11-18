import SwiftUI

struct GenreMoviesSelection: View {
    let title: String
    let movies: [Movie]
    
    let onReachEnd: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.top, 10)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 20) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            DetailMovieView(viewDetailModel: DetailViewModel(movieID: movie.id ))
                        } label: { VStack(alignment: .center, spacing: 10){
                            AsyncImage(url: movie.posterURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity)
                                    .frame(minHeight: 150)
                                    .cornerRadius(16)
                                    .shadow(radius: 10)
                            } placeholder: {
                                ProgressView()
                                    .frame(height: 450)
                            }
                            
                            Text(movie.title)
                                .font(.title.bold())
                                .padding(10)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        }.onAppear {
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


