import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)

struct HelpView: View {
    var onBack: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    helpSection(
                        title: "Using the app",
                        text: "Browse places on Home, explore categories in Explore, and find locations on the Map. Tap a place to see details, save favorites, and open in the map."
                    )
                    helpSection(
                        title: "Saved Places",
                        text: "Tap the bookmark icon on a place card or on the place detail screen to save it. Your saved places appear in Profile → Saved Places."
                    )
                    helpSection(
                        title: "Profile & Settings",
                        text: "Create a profile or continue as a guest. In Settings you can manage notifications, location, and reset local data."
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
    }

    private var header: some View {
        HStack(spacing: 16) {
            Button {
                onBack?()
            } label: {
                Image("backButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .background(cellBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(cellBorder, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            Text("Help")
                .font(.interSemiBold(size: 20))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }

    private func helpSection(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.interSemiBold(size: 16))
                .foregroundStyle(.white)
            Text(text)
                .font(.interRegular(size: 15))
                .foregroundStyle(subtitleGray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cellBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    HelpView(onBack: { })
}
