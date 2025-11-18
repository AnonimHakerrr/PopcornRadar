import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject var watchlistVM: WatchlistViewModel
    @State private var reloadID = UUID()
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear.backgroundView().ignoresSafeArea()
                
                if watchlistVM.watchlist.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Список пустий")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Text("Додайте фільми щоб переглянути пізніше 🎬")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 60)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(watchlistVM.watchlist, id: \.id) { saved in
                                
                                NavigationLink {
                                    DetailMovieView(
                                        viewDetailModel: DetailViewModel(movieID: saved.id)
                                    )
                                } label: { HStack(spacing: 12) {
                                    ReliableAsyncImage(url: saved.posterURL)
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(10)
                                        .clipped()
                                    
                                    
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(saved.title)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .lineLimit(2)
                                        
                                        
                                        
                                        
                                        Text("Деталі")
                                            .font(.callout)
                                            .foregroundColor(.orange)
                                    }
                                }
                                    
                                    Spacer()
                                    Button {
                                        watchlistVM.remove(saved)
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.white)
                                            .frame(width: 38, height: 38)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Дивитись пізніше")
        }
    }
}
