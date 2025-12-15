import SwiftUI
import Kingfisher

struct MovieSection<Destination: View>: View {
    let title: String
    let movies: [Movie]
    let seeAllDestination: (() -> Destination)?
    
    // Без "Всі"
    init(title: String, movies: [Movie]) where Destination == EmptyView {
        self.title = title
        self.movies = movies
        self.seeAllDestination = nil
    }
    
    // З "Всі"
    init(title: String, movies: [Movie], seeAllDestination: @escaping () -> Destination) {
        self.title = title
        self.movies = movies
        self.seeAllDestination = seeAllDestination
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Spacer()
                if let seeAllDestination {
                    NavigationLink {
                        seeAllDestination()
                    } label: {
                        Text("Всі")
                            .font(.subheadline.bold())
                    }
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            DetailMovieView(viewDetailModel: DetailViewModel(movieID: movie.id))
                        } label: {
                            VStack {
                                KFImage(movie.posterURL)
                                    .placeholder {
                                        ProgressView()
                                            .frame(width: 140, height: 210)
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 140, height: 210)
                                    .cornerRadius(12)
                                
                                
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
