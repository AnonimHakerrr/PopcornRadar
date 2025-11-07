import SwiftUI

struct MovieSection: View {
    let title: String
    let movies: [Movie]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            DetailMovieView(viewDetailModel: DetailViewModel(movieID: movie.id ))
                        } label: {
                            VStack {
                                AsyncImage(url: movie.posterURL) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 140, height: 210)
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 140, height: 210)
                                }
                                
                                Text(movie.title)
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .frame(width: 140)
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
