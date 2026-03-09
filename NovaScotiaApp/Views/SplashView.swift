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

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 0) {
                Spacer()

                logoSection

                titleSection

                Spacer()
                    .frame(height: 80)

                waveSection
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                logoScale = 1
                logoOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                titleOpacity = 1
            }
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                wavePhase = .pi * 2
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: false).delay(0.5)) {
                shimmerOffset = 200
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [splashBackgroundDark, splashBackgroundMid, splashBackgroundDark],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var logoSection: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            splashAccent.opacity(0.35),
                            splashAccent.opacity(0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 70
                    )
                )
                .frame(width: 140, height: 140)
                .blur(radius: 8)

            Circle()
                .stroke(splashAccent.opacity(0.5), lineWidth: 2)
                .frame(width: 100, height: 100)

            Circle()
                .stroke(splashAccentLight.opacity(0.25), lineWidth: 1)
                .frame(width: 88, height: 88)

            Text("🌊")
                .font(.system(size: 44))
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
        }
        .padding(.bottom, 28)
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("Nova Scotia")
                .font(.interSemiBold(size: 28))
                .foregroundStyle(.white)

            Text("Island Guide")
                .font(.interRegular(size: 18))
                .foregroundStyle(splashAccentLight.opacity(0.9))

            Text("Discover • Explore • Save")
                .font(.interRegular(size: 13))
                .foregroundStyle(Color.rgb(156, 166, 200).opacity(0.8))
                .padding(.top, 6)
        }
        .opacity(titleOpacity)
    }

    private var waveSection: some View {
        ZStack(alignment: .bottom) {
            WaveShape(phase: wavePhase, amplitude: 12, frequency: 1.2)
                .fill(
                    LinearGradient(
                        colors: [splashWater.opacity(0.9), splashWaterHighlight.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 120)
                .overlay(
                    WaveShape(phase: wavePhase + 0.5, amplitude: 8, frequency: 1.5)
                        .stroke(splashAccent.opacity(0.3), lineWidth: 1)
                        .frame(height: 120)
                )

            WaveShape(phase: wavePhase + 1, amplitude: 10, frequency: 1.0)
                .fill(splashWater.opacity(0.7))
                .frame(height: 90)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var frequency: CGFloat

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.height * 0.5
        let width = rect.width
        let step = width / 80

        path.move(to: CGPoint(x: 0, y: rect.height + 10))
        path.addLine(to: CGPoint(x: 0, y: midY))

        for x in stride(from: 0, through: width + step, by: step) {
            let relativeX = x / width
            let y = midY + sin(relativeX * .pi * frequency * 2 + phase) * amplitude
            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.addLine(to: CGPoint(x: width + 20, y: rect.height + 10))
        path.closeSubpath()
        return path
    }
}

#Preview {
    SplashView()
}
