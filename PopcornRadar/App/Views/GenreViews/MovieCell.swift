import SwiftUI

struct MovieCell: View {
    let movie: Movie
    let width: CGFloat
    let isPortrait: Bool

    var body: some View {
        VStack(spacing: 10) {

            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                    .cornerRadius(16)
                    .shadow(radius: 10)
            } placeholder: {
                ProgressView()
                    .frame(width: width, height: width * (isPortrait ? 1.8 : 1.3))
            }

            Text(movie.title)
                .font(isPortrait ? .title2.bold() : .title3.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)
                .lineLimit(isPortrait ? nil : 2)
                .frame(width: width)
        }
    }
}
