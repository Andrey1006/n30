import SwiftUI

private let onboardingAccent = Color.rgb(185, 115, 29)

struct OnboardingPageItem {
    let emoji: String
    let topTitle: String?
    let heading: String
    let description: String
    let buttonTitle: String
}

private let onboardingPages: [OnboardingPageItem] = [
    OnboardingPageItem(
        emoji: "🌊",
        topTitle: "Nova Scotia Island Guide",
        heading: "Discover Nova Scotia Island",
        description: "Explore beaches, diving spots, and scenic trails in one place. Save favorites and plan your day in minutes.",
        buttonTitle: "Next"
    ),
    OnboardingPageItem(
        emoji: "🏖️",
        topTitle: nil,
        heading: "Browse by Categories",
        description: "Find places for relaxation, adventure, food, and nightlife. Open any card to see details, tips, and directions.",
        buttonTitle: "Next"
    ),
    OnboardingPageItem(
        emoji: "💬",
        topTitle: nil,
        heading: "Tips & Highlights",
        description: "Each place comes with highlights, what to do, and local tips. Save your favorites and open any spot on the map to plan your perfect day.",
        buttonTitle: "Get Started"
    )
]

struct OnboardingView: View {
    @State private var currentPage = 0
    var onComplete: (() -> Void)?
    var onSkip: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $currentPage) {
                ForEach(Array(onboardingPages.enumerated()), id: \.offset) { index, item in
                    OnboardingPageView(
                        item: item,
                        currentPage: $currentPage,
                        onNext: {
                            if index < onboardingPages.count - 1 {
                                currentPage = index + 1
                            } else {
                                onComplete?()
                            }
                        }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            Button("Skip") {
                onSkip?()
            }
            .font(.interMedium(size: 16))
            .foregroundStyle(onboardingAccent)
            .padding(.top, 16)
            .padding(.trailing, 24)
        }
    }
}

private struct OnboardingPageView: View {
    let item: OnboardingPageItem
    @Binding var currentPage: Int
    var onNext: () -> Void

    init(item: OnboardingPageItem, currentPage: Binding<Int>, onNext: @escaping () -> Void) {
        self.item = item
        _currentPage = currentPage
        self.onNext = onNext
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Spacer()
            Text(item.emoji)
                .font(.system(size: 40))
                .frame(width: 80, height: 80)
                .background(onboardingAccent)
                .clipShape(Circle())
                .padding(.top, item.topTitle == nil ? 80 : 0)
                .padding(.bottom, 24)
            
            if let topTitle = item.topTitle {
                Text(topTitle)
                    .font(.interMedium(size: 24))
                    .foregroundStyle(.white)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
            }
            
            Spacer()

            Text(item.heading)
                .font(.interSemiBold(size: 24))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)

            Text(item.description)
                .font(.interRegular(size: 15))
                .foregroundStyle(Color.rgb(156, 166, 200))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

            Spacer(minLength: 0)

            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index == currentPage ? Color.rgb(246, 196, 69) : Color.rgb(27, 34, 59))
                        .frame(width: 32, height: 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            Button(item.buttonTitle) {
                onNext()
            }
            .font(.interSemiBold(size: 16))
            .foregroundStyle(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(onboardingAccent)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.onboardingBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    OnboardingView(
        onComplete: { },
        onSkip: { }
    )
}
