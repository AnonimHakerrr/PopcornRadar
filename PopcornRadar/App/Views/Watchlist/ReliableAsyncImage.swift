import SwiftUI

struct ReliableAsyncImage: View {
    let url: URL?
    @State private var reloadID = UUID()
    @State private var retryCount = 0
    
    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity)
                
            case .failure(_):
                Color.gray.opacity(0.2)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.white.opacity(0.6))
                    )
                    .onAppear {
                        retryLoad()
                    }
                
            case .empty:
                ProgressView()
            @unknown default:
                Color.gray.opacity(0.2)
            }
        }
        .id(reloadID)
    }
    
    private func retryLoad() {
        guard retryCount < 3 else { return } // максимум 3 спроби
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            retryCount += 1
            reloadID = UUID()
        }
    }
}
