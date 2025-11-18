import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.backgroundView().ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        
                        Image(systemName: "magnifyingglass")
                        TextField("Пошук фільмів...", text: $viewModel.query)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                        if !viewModel.query.isEmpty {
                            Button {
                                viewModel.query = ""
                            } label: {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .foregroundColor(.white)
                                    
                                }else{Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.searchResults) { movie in
                                NavigationLink {
                                    DetailMovieView(viewDetailModel: DetailViewModel(movieID: movie.id))
                                } label: {
                                    HStack(spacing: 12) {
                                        AsyncImage(url: movie.posterURL) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                        }
                                        .frame(width: 80, height: 120)
                                        .cornerRadius(8)
                                        .clipped()
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(movie.title)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                            
                                            Label("\(movie.voteAverage, specifier: "%.1f")", systemImage: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.subheadline)
                                            
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Пошук")
        }
    }
}
