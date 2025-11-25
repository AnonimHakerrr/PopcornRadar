import SwiftUI


struct SearchNotStartedView: View {
    
      let showEmptyIcon : Bool
    
    var body: some View {
        GeometryReader { geo in
            
            let isLandscape = geo.size.width > geo.size.height
            
            let circleSize: CGFloat = isLandscape ? 100 : 140
            let iconSize: CGFloat = isLandscape ? 40 : 60
            let spacing: CGFloat = isLandscape ? 10 : 16

            VStack(spacing: spacing) {

                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.06))
                        .frame(width: circleSize, height: circleSize)

                    Image(systemName: "magnifyingglass")
                        .font(.system(size: iconSize, weight: .light))
                        .foregroundColor(.white.opacity(0.7))
                        .opacity(showEmptyIcon ? 1 : 0)
                        .scaleEffect(showEmptyIcon ? 1 : 0.8)
                        .animation(
                            .snappy(duration: 0.35, extraBounce: 0.15),
                            value: showEmptyIcon
                        )
                }

                Text("Знайдіть свій улюблений фільм")
                    .foregroundColor(.white.opacity(0.7))
                    .font(isLandscape ? .headline : .title3)

                Text("Почніть вводити назву у полі зверху")
                    .foregroundColor(.white.opacity(0.4))
                    .font(isLandscape ? .caption : .subheadline)
            }
            .frame(maxWidth: geo.size.width , maxHeight: geo.size.height )
        }
        .frame(minHeight: 250)
    }
}
