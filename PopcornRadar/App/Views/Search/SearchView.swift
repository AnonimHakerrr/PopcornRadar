import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var showEmptyIcon = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.backgroundView().ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                    }
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Пошук")
                            .font(.title)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Пошук фільмів...", text: $viewModel.query)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            
                            if !viewModel.query.isEmpty {
                                Button {
                                    viewModel.query = ""
                                    showEmptyIcon = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        showEmptyIcon = true
                                    }
                                } label: {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .foregroundColor(.white)
                                    } else {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        if viewModel.query.isEmpty && showEmptyIcon{
                            
                            SearchNotStartedView(showEmptyIcon: showEmptyIcon)
                        }
                        
                        
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
                                    }.padding(.horizontal)
                                }
                            }
                        }
                    }.padding(.top)
                }
            }.simultaneousGesture(
                DragGesture().onChanged { _ in
                    hideKeyboard()
                }
            )
            
        }
    }
}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),to: nil, from: nil, for: nil)
    }
}
