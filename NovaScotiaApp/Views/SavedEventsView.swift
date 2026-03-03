import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)

struct SavedEventsView: View {
    var onBack: (() -> Void)?

    private var savedEventIds: [String] {
        UserDefaultsStorage.savedEventIds
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            emptyState
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

            Text("Saved Events")
                .font(.interSemiBold(size: 20))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("No saved events yet")
                .font(.interRegular(size: 16))
                .foregroundStyle(subtitleGray)
            Text("Events you save will appear here")
                .font(.interRegular(size: 14))
                .foregroundStyle(subtitleGray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SavedEventsView(onBack: { })
}
