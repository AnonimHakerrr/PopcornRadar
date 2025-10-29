import SwiftUI

struct MainTabView:View {
    var body: some View {
        TabView{
            MoviesView()
                .tabItem {
                    Label("Головна", systemImage: "house.fill")
                }
            GenresView()
                .tabItem {
                    Label("Категорії", systemImage: "square.grid.2x2.fill")
                }
            
            WatchlistView()
                .tabItem {
                    Label("Дивитись пізніше", systemImage: "heart.fill")
                }
            
            SearchView()
                .tabItem {
                    Label("Пошук", systemImage: "magnifyingglass")
                }
        }
        .tint(.pink)
    }
}
#Preview {
    MainTabView()
    
}
