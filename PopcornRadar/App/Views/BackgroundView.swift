import SwiftUI

struct BackgroundView:ViewModifier {
    func body(content: Content) -> some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [.pink, .purple ,.black]),
                startPoint: .topLeading,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            Color.black
                .opacity(0.6)
                .ignoresSafeArea()
            
            content
        }
    }
}
extension View {
    func backgroundView() -> some View {
        self.modifier(BackgroundView())
    }
}
