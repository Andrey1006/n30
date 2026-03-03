import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    @State private var isDetailPushed = false
    @State private var showNotifications = false
    @State private var showSettings = false
    @State private var showSavedPlaces = false
    @State private var showSavedEvents = false
    @State private var showHelp = false
    @State private var placeToShowOnMapId: String?
    @State private var showExploreCategory = false
    @State private var exploreCategoryName: String?

    var onLogOut: (() -> Void)?

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeView(
                            defaultPlaceDetail: defaultPlaceDetail,
                            onOpenInMap: { placeToShowOnMapId = $0; selectedTab = .map },
                            onDetailAppear: { isDetailPushed = true },
                            onDetailDisappear: { isDetailPushed = false },
                            onNotificationsTap: { showNotifications = true },
                            onSettingsTap: { showSettings = true }
                        )
                    }
                case .explore:
                    ExploreView(onExploreItemTap: { index in
                        exploreCategoryName = NovaScotiaApp.exploreCategoryName(forIndex: index)
                        showExploreCategory = true
                    })
                case .map:
                    MapView(initialSelectedPlaceId: placeToShowOnMapId, onPlaceSeen: { placeToShowOnMapId = nil })
                case .profile:
                    ProfileView(
                        onLogOut: onLogOut ?? { },
                        onSavedPlaces: { showSavedPlaces = true },
                        onSavedEvents: { showSavedEvents = true },
                        onSettings: { showSettings = true },
                        onHelp: { showHelp = true }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab)
                .opacity(isDetailPushed ? 0 : 1)
                .allowsHitTesting(!isDetailPushed)
                .animation(.easeInOut(duration: 0.2), value: isDetailPushed)
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showNotifications) {
            NotificationsView(onBack: { showNotifications = false }, onClearAll: { })
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(
                onBack: { showSettings = false },
                onResetData: { showSettings = false },
                onLogOut: { showSettings = false; onLogOut?() },
                onDeleteAccount: { showSettings = false; onLogOut?() }
            )
        }
        .sheet(isPresented: $showSavedPlaces) {
            NavigationStack {
                SavedPlacesView(
                    defaultPlaceDetail: defaultPlaceDetail,
                    onBack: { showSavedPlaces = false },
                    onOpenInMap: { placeToShowOnMapId = $0; selectedTab = .map; showSavedPlaces = false }
                )
            }
        }
        .sheet(isPresented: $showSavedEvents) {
            SavedEventsView(onBack: { showSavedEvents = false })
        }
        .sheet(isPresented: $showHelp) {
            HelpView(onBack: { showHelp = false })
        }
        .sheet(isPresented: $showExploreCategory) {
            NavigationStack {
                ExploreCategoryView(
                    categoryName: exploreCategoryName ?? "",
                    defaultPlaceDetail: defaultPlaceDetail,
                    onBack: { showExploreCategory = false },
                    onOpenInMap: { placeToShowOnMapId = $0; selectedTab = .map; showExploreCategory = false }
                )
            }
        }
    }
}

private let defaultPlaceDetail = PlaceDetailData(
    highlights: [],
    whatToDo: [],
    tips: []
)

#Preview {
    MainTabView(onLogOut: { })
}
