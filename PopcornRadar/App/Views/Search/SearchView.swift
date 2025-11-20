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
                                showEmptyIcon = false
                                
                                // даємо UI час очистити results
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    showEmptyIcon = true
                                }
                                
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
                    
                    if viewModel.query.isEmpty && showEmptyIcon{
                        VStack(spacing: 16) {
                            
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.06))
                                    .frame(width: 140, height: 140)
                                    .blur(radius: 0)
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 60, weight: .light))
                                    .foregroundColor(.white.opacity(0.7))
                                    .opacity(showEmptyIcon ? 1 : 0)
                                    .scaleEffect(showEmptyIcon ? 1 : 0.8)
                                    .animation(
                                        .snappy(duration: 0.35, extraBounce: 0.15),
                                        value: showEmptyIcon
                                    )
                                
                            }
                            .padding(.top, 80)
                            .transition(.opacity.combined(with: .scale))
                            
                            Text("Знайдіть свій улюблений фільм")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                                .padding(.horizontal)
                            
                            Text("Почніть вводити назву у полі зверху")
                                .foregroundColor(.white.opacity(0.4))
                                .font(.subheadline)
                            
                            
                        }
                    }
                    
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
                    .simultaneousGesture(
                        DragGesture().onChanged { _ in
                            hideKeyboard()
                        }
                    )
                    .padding(.top)
                }
            }
            .navigationTitle("Пошук")
        }
    }
}
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
