import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)
private let ratingYellow = Color.rgb(246, 196, 69)

struct SavedPlacesView: View {
    var defaultPlaceDetail: PlaceDetailData = PlaceDetailData(highlights: [], whatToDo: [], tips: [])
    var onBack: (() -> Void)?
    var onOpenInMap: ((String) -> Void)?

    private var savedPlaces: [PlaceItem] {
        UserDefaultsStorage.savedPlaceIds.compactMap { place(byId: $0) }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            if savedPlaces.isEmpty {
                emptyState
            } else {
                listContent
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

            Text("Saved Places")
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
            Text("No saved places yet")
                .font(.interRegular(size: 16))
                .foregroundStyle(subtitleGray)
            Text("Save places from Home or place details")
                .font(.interRegular(size: 14))
                .foregroundStyle(subtitleGray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var listContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(savedPlaces) { place in
                    NavigationLink(destination: PlaceDetailView(
                        place: place,
                        detail: placeDetailData(for: place.id) ?? defaultPlaceDetail,
                        onBookmark: { },
                        onOpenInMap: { onOpenInMap?(place.id) }
                    )) {
                        HStack(spacing: 12) {
                            Image(place.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(place.title)
                                    .font(.interSemiBold(size: 15))
                                    .foregroundStyle(.white)
                                Text(place.category)
                                    .font(.interRegular(size: 13))
                                    .foregroundStyle(subtitleGray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundStyle(subtitleGray)
                        }
                        .padding(16)
                        .background(cellBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(cellBorder, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    SavedPlacesView(onBack: { })
}
