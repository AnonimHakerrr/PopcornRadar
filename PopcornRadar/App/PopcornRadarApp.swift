import SwiftUI

@main
struct PopcornRadarApp: App {
    @StateObject  var watchlistVM = WatchlistViewModel()
    var body: some Scene {
        WindowGroup {
            MainTabView().environmentObject(watchlistVM)
        }
    }
}
