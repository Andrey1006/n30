import SwiftUI

private let splashBackgroundDark = Color.rgb(7, 7, 19)
private let splashBackgroundMid = Color.rgb(12, 18, 38)
private let splashAccent = Color.rgb(185, 115, 29)
private let splashAccentLight = Color.rgb(246, 196, 69)
private let splashWater = Color.rgb(27, 34, 59)
private let splashWaterHighlight = Color.rgb(43, 55, 92)

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var wavePhase: CGFloat = 0
    @State private var shimmerOffset: CGFloat = -200
    @State private var isRotating = false

    var body: some View {
        ZStack {
            Image(.splashBack)
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()
                Spacer()
                Image(.loade)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .rotationEffect(.degrees(isRotating ? 0 : 360))
                    .animation(
                        .linear(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: isRotating
                    )
                    .onAppear {
                        isRotating = true
                    }
                
                Text("Loading...")
                    .font(.interMedium(size: 18))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }
}


#Preview {
    SplashView()
}
