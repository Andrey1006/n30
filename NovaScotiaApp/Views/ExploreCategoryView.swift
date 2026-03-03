import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)

private let exploreIndexToCategory: [Int: String] = [
    0: "Diving",
    1: "Beaches",
    2: "Food & Cafes",
    3: "Scenic Trails",
    4: "Tours",
    5: "Nightlife",
    6: "Family",
    7: "Casino & Entertainment"
]

struct ExploreCategoryView: View {
    let categoryName: String
    var defaultPlaceDetail: PlaceDetailData = PlaceDetailData(highlights: [], whatToDo: [], tips: [])
    var onBack: (() -> Void)?
    var onOpenInMap: ((String) -> Void)?

    private var places: [PlaceItem] {
        allPlaceItems.filter { $0.category == categoryName }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            if places.isEmpty {
                Text("No places in this category yet")
                    .font(.interRegular(size: 16))
                    .foregroundStyle(subtitleGray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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

            Text(categoryName)
                .font(.interSemiBold(size: 20))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }

    private var listContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(places) { place in
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

func exploreCategoryName(forIndex index: Int) -> String? {
    exploreIndexToCategory[index]
}
