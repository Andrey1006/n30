import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let accentGold = Color.rgb(246, 196, 69)

private let sampleNotifications = [
    "New featured place: Emerald Cove Beach",
    "Weekend events updated",
    "Saved place tip: Best time to visit Kelp Forest Bay",
    "Tonight: Live Jazz at Nova Scotia Casino",
    "New café: Harbor Lights Café"
]

struct NotificationsView: View {
    @State private var notifications: [String] = sampleNotifications

    var onBack: (() -> Void)?
    var onClearAll: (() -> Void)?

    var body: some View {
        VStack(spacing: 24) {
            header
            notificationsList
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

            Text("Notifications")
                .font(.interSemiBold(size: 24))
                .foregroundStyle(.white)

            Spacer()

            Button("Clear all") {
                onClearAll?()
                notifications.removeAll()
            }
            .font(.interSemiBold(size: 14))
            .foregroundStyle(accentGold)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var notificationsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(Array(notifications.enumerated()), id: \.offset) { _, text in
                    Text(text)
                        .font(.interRegular(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(cellBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(cellBorder, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    NotificationsView(
        onBack: { },
        onClearAll: { }
    )
}
