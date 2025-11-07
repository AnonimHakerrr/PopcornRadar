import SwiftUI

struct SearchView: View {
    @State private var query = ""
    //@State private var seatchResults: [SearchResult] = []
    var body: some View {
        NavigationStack {
            VStack {
                
               
                
                
            }
            .backgroundView()
            .navigationTitle("Пошук")
            .searchable(text: $query)
            
        }
       
    }
}

