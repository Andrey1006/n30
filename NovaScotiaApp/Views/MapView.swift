import SwiftUI
import MapKit

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)
private let accentOrange = Color.rgb(185, 115, 29)
private let accentGold = Color.rgb(246, 196, 69)

struct MapPlaceItem: Identifiable {
    let id: String
    let title: String
    let imageName: String
    let category: String
    let rating: String
    let distance: String
    let coordinate: CLLocationCoordinate2D
    let bestTime: String
    let price: String
    let duration: String
}

private let mapPlaces: [MapPlaceItem] = [
    MapPlaceItem(id: "1", title: "Emerald Cove Beach", imageName: "EmeraldCoveBeach", category: "Beaches", rating: "4.7", distance: "1.9 km", coordinate: CLLocationCoordinate2D(latitude: 44.6488, longitude: -63.5752), bestTime: "Morning", price: "$$", duration: "2-3h"),
    MapPlaceItem(id: "4", title: "Kelp Forest Bay", imageName: "KelpForestBay", category: "Diving", rating: "4.6", distance: "5.4 km", coordinate: CLLocationCoordinate2D(latitude: 44.6620, longitude: -63.5600), bestTime: "Summer", price: "$", duration: "3-4h"),
    MapPlaceItem(id: "2", title: "Harbor Lights Café", imageName: "HarborLightsCafe", category: "Food & Cafes", rating: "4.8", distance: "1.2 km", coordinate: CLLocationCoordinate2D(latitude: 44.6420, longitude: -63.5820), bestTime: "Lunch", price: "$$", duration: "1-2h"),
    MapPlaceItem(id: "5", title: "Coastal Wind Path", imageName: "CoastalWindPath", category: "Scenic Trails", rating: "4.7", distance: "5.2 km", coordinate: CLLocationCoordinate2D(latitude: 44.6720, longitude: -63.5950), bestTime: "Morning", price: "Free", duration: "2-3h"),
    MapPlaceItem(id: "3", title: "Nova Scotia Casino", imageName: "NovaScotiaCasino", category: "Casino & Entertainment", rating: "4.6", distance: "2.2 km", coordinate: CLLocationCoordinate2D(latitude: 44.6380, longitude: -63.5680), bestTime: "Evening", price: "$$$", duration: "2h+")
]

private let defaultRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 44.6488, longitude: -63.5752),
    span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
)

enum MapSheetHeight {
    case collapsed
    case partial
    case full

    var fraction: CGFloat {
        switch self {
        case .collapsed: return 0.28
        case .partial: return 0.52
        case .full: return 0.88
        }
    }
}

private let mapDefaultPlaceDetail = PlaceDetailData(highlights: [], whatToDo: [], tips: [])

struct MapView: View {
    var initialSelectedPlaceId: String?
    var onPlaceSeen: (() -> Void)?

    @State private var searchText = ""
    @State private var region = defaultRegion
    @State private var selectedPlace: MapPlaceItem?
    @State private var sheetHeight: MapSheetHeight = .collapsed
    @State private var dragOffset: CGFloat = 0
    @State private var placeDetailToShow: PlaceItem?

    private var filteredMapPlaces: [MapPlaceItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty { return mapPlaces }
        return mapPlaces.filter {
            $0.title.lowercased().contains(query) || $0.category.lowercased().contains(query)
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                mapLayer
                searchBar
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 8)

                VStack {
                    Spacer()
                    bottomSheet(geo: geo)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(screenBackground)
        .onAppear {
            if let id = initialSelectedPlaceId, !id.isEmpty,
               let place = mapPlaces.first(where: { $0.id == id }) {
                selectedPlace = place
                region = MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                sheetHeight = .partial
                onPlaceSeen?()
            }
        }
        .fullScreenCover(item: $placeDetailToShow) { place in
            PlaceDetailView(
                place: place,
                detail: placeDetailData(for: place.id) ?? mapDefaultPlaceDetail,
                onBookmark: { },
                onOpenInMap: { placeDetailToShow = nil }
            )
        }
    }

    private var mapLayer: some View {
        Map(coordinateRegion: $region, annotationItems: filteredMapPlaces) { place in
            MapAnnotation(coordinate: place.coordinate) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(accentGold)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(subtitleGray)
            TextField("Search places...", text: $searchText, prompt:
                Text("Search places...")
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
    }

    private func bottomSheet(geo: GeometryProxy) -> some View {
        let maxH = geo.size.height
        let targetH = maxH * sheetHeight.fraction + dragOffset
        let sheetH = min(max(180, targetH), maxH - 100)

        return VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .fill(subtitleGray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 8)

            if let place = selectedPlace {
                placeDetailContent(place: place)
            } else {
                placesNearbyContent
            }
        }
        .frame(height: sheetH)
        .frame(maxWidth: .infinity)
        .background(screenBackground)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 24
            )
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = -value.translation.height
                }
                .onEnded { value in
                    withAnimation(.easeOut(duration: 0.2)) {
                        let predicted = sheetHeight.fraction * geo.size.height - value.predictedEndTranslation.height
                        if predicted < geo.size.height * 0.4 {
                            sheetHeight = .collapsed
                            if value.translation.height > 80 { selectedPlace = nil }
                        } else if predicted < geo.size.height * 0.7 {
                            sheetHeight = .partial
                        } else {
                            sheetHeight = .full
                        }
                        dragOffset = 0
                    }
                }
        )
    }

    private var placesNearbyContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Places near this area")
                    .font(.interSemiBold(size: 18))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filteredMapPlaces) { place in
                            MapPlaceRowCard(place: place, compact: true) {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    selectedPlace = place
                                    sheetHeight = .partial
                                    region = MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            }
        }
    }

    private func placeDetailContent(place: MapPlaceItem) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Button("View Details") {
                        if let item = NovaScotiaApp.place(byId: place.id) {
                            placeDetailToShow = item
                        }
                    }
                    .font(.interSemiBold(size: 16))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(accentOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    Button("Close") {
                        withAnimation(.easeOut(duration: 0.25)) {
                            selectedPlace = nil
                            sheetHeight = .collapsed
                        }
                    }
                    .font(.interSemiBold(size: 16))
                    .foregroundStyle(accentGold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(accentGold, lineWidth: 2)
                    )
                }
                .padding(.horizontal, 20)

                Text(place.title)
                    .font(.interSemiBold(size: 22))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)

                HStack(spacing: 8) {
                    Text(place.category)
                        .font(.interRegular(size: 14))
                        .foregroundStyle(subtitleGray)
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(accentGold)
                    Text(place.rating)
                        .font(.interRegular(size: 14))
                        .foregroundStyle(subtitleGray)
                    Text(place.distance)
                        .font(.interRegular(size: 14))
                        .foregroundStyle(subtitleGray)
                }
                .padding(.horizontal, 20)

                HStack(spacing: 12) {
                    infoCard(label: "Best time", value: place.bestTime)
                    infoCard(label: "Price", value: place.price)
                    infoCard(label: "Duration", value: place.duration)
                }
                .padding(.horizontal, 20)

                Text("Nearby")
                    .font(.interSemiBold(size: 18))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    ForEach(filteredMapPlaces.filter { $0.id != place.id }) { nearby in
                        MapPlaceRowCard(place: nearby, compact: false) {
                            withAnimation(.easeOut(duration: 0.25)) {
                                selectedPlace = nearby
                                sheetHeight = .partial
                                region = MKCoordinateRegion(center: nearby.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .padding(.top, 8)
        }
    }

    private func infoCard(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.interRegular(size: 12))
                .foregroundStyle(subtitleGray)
            Text(value)
                .font(.interSemiBold(size: 14))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cellBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct MapPlaceRowCard: View {
    let place: MapPlaceItem
    let compact: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
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
                Spacer()
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
        .frame(minWidth: compact ? 280 : nil, maxWidth: compact ? nil : .infinity)
    }
}

#Preview {
    MapView()
}
