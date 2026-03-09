import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)
private let ratingYellow = Color.rgb(246, 196, 69)

struct PlaceItem: Identifiable, Hashable {
    let id: String
    let title: String
    let imageName: String
    let category: String
    let rating: String
    let distance: String
    let description: String
}

private let categories = ["All", "Dining", "Beaches", "Diving", "Snorkeling", "Food & Cafes", "Scenic Trails", "Scenic Viewpoints", "Casino & Entertainment"]

struct HomeView: View {
    @State private var selectedCategoryIndex = 0
    @State private var searchText = ""
    @State private var savedPlaceIds: Set<String> = []

    var defaultPlaceDetail: PlaceDetailData = PlaceDetailData(highlights: [], whatToDo: [], tips: [])
    var onOpenInMap: ((String) -> Void)?
    var onDetailAppear: (() -> Void)?
    var onDetailDisappear: (() -> Void)?
    var onNotificationsTap: (() -> Void)?
    var onSettingsTap: (() -> Void)?

    private var filteredPlaces: [PlaceItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return allPlaceItems.filter { place in
            let categoryMatch = selectedCategoryIndex == 0 || place.category == categories[selectedCategoryIndex]
            let searchMatch = query.isEmpty
                || place.title.lowercased().contains(query)
                || place.category.lowercased().contains(query)
                || place.description.lowercased().contains(query)
            return categoryMatch && searchMatch
        }
    }

    private var featuredPlacesFiltered: [PlaceItem] {
        Array(filteredPlaces.prefix(3))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            searchBar
            categoryFilter
            contentScroll
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
        .onAppear {
            savedPlaceIds = Set(UserDefaultsStorage.savedPlaceIds)
        }
    }

    private var header: some View {
        HStack {
            Text("📍 Nova Scotia Island")
                .font(.interRegular(size: 14))
                .foregroundStyle(.white)
            Spacer()
            Button {
                onNotificationsTap?()
            } label: {
                Image("notifButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            Button {
                onSettingsTap?()
            } label: {
                Image("settingsButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(subtitleGray)
            TextField("Search places, activities...", text: $searchText, prompt:
                Text("Search places, activities...")
                    .font(.interRegular(size: 16))
                    .foregroundColor(subtitleGray)
            )
            .font(.interRegular(size: 16))
            .foregroundStyle(.white)
        }
        .padding(16)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cellBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, title in
                    Button {
                        selectedCategoryIndex = index
                    } label: {
                        Text(title)
                            .font(.interMedium(size: 14))
                            .foregroundStyle(index == selectedCategoryIndex ? .white : subtitleGray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(index == selectedCategoryIndex ? Color.rgb(18, 24, 48) : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(index == selectedCategoryIndex ? cellBorder : Color.clear, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 24)
    }

    private var contentScroll: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                featuredSection
                nearYouSection
            }
            .padding(.bottom, 100)
        }
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Today")
                .font(.interSemiBold(size: 18))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(featuredPlacesFiltered) { place in
                        NavigationLink(destination: PlaceDetailView(
                            place: place,
                            detail: placeDetailData(for: place.id) ?? defaultPlaceDetail,
                            onBookmark: { },
                            onOpenInMap: { onOpenInMap?(place.id) }
                        )
                        .onAppear { onDetailAppear?() }
                        .onDisappear { onDetailDisappear?() }
                        ) {
                            PlaceCardView(
                                place: place,
                                isHorizontal: true,
                                isSaved: savedPlaceIds.contains(place.id),
                                onSaveTap: { toggleSave(place.id) }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private var nearYouSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Near You")
                .font(.interSemiBold(size: 18))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)

            VStack(spacing: 16) {
                ForEach(filteredPlaces) { place in
                    NavigationLink(destination: PlaceDetailView(
                        place: place,
                        detail: placeDetailData(for: place.id) ?? defaultPlaceDetail,
                        onBookmark: { },
                        onOpenInMap: { onOpenInMap?(place.id) }
                    )
                    .onAppear { onDetailAppear?() }
                    .onDisappear { onDetailDisappear?() }
                    ) {
                        PlaceCardView(
                            place: place,
                            isHorizontal: false,
                            isSaved: savedPlaceIds.contains(place.id),
                            onSaveTap: { toggleSave(place.id) }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func toggleSave(_ id: String) {
        UserDefaultsStorage.toggleSavedPlace(id: id)
        savedPlaceIds = Set(UserDefaultsStorage.savedPlaceIds)
    }
}

private struct PlaceCardView: View {
    let place: PlaceItem
    let isHorizontal: Bool
    let isSaved: Bool
    let onSaveTap: () -> Void

    var body: some View {
        if isHorizontal {
            horizontalCard
        } else {
            verticalCard
        }
    }

    private var horizontalCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageBlock
            textBlock
            Spacer()
        }
        .frame(width: 280)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cellBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var verticalCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageBlock
            textBlock
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cellBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var imageBlock: some View {
        ZStack(alignment: .topTrailing) {
            Image(place.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: isHorizontal ? 160 : 180)
                .clipped()

            Button(action: onSaveTap) {
                Image("favoriteButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .padding(16)
        }
    }

    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(place.title)
                .font(.interSemiBold(size: 17))
                .foregroundStyle(.white)

            HStack(spacing: 6) {
                Text(place.category)
                    .font(.interRegular(size: 13))
                    .foregroundStyle(subtitleGray)
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(ratingYellow)
                Text(place.rating)
                    .font(.interRegular(size: 13))
                    .foregroundStyle(subtitleGray)
                Text(place.distance)
                    .font(.interRegular(size: 13))
                    .foregroundStyle(subtitleGray)
            }

            Text(place.description)
                .font(.interRegular(size: 14))
                .foregroundStyle(subtitleGray)
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomeView(onNotificationsTap: { }, onSettingsTap: { })
}
