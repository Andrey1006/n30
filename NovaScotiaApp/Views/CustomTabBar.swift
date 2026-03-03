import SwiftUI

private let tabBarBackground = Color.rgb(7, 7, 19)
private let tabActiveColor = Color.rgb(246, 196, 69)
private let tabInactiveColor = Color.rgb(156, 166, 200)

enum TabItem: Int, CaseIterable {
    case home = 0
    case explore
    case map
    case profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .map: return "Map"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .explore: return "magnifyingglass"
        case .map: return "map"
        case .profile: return "person"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    var onTap: ((TabItem) -> Void)?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                CustomTabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    onTap: {
                        selectedTab = tab
                        onTap?(tab)
                    }
                )
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
        .background(tabBarBackground)
    }
}

private struct CustomTabBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 24))
                Text(tab.title)
                    .font(.interMedium(size: 11))
            }
            .foregroundStyle(isSelected ? tabActiveColor : tabInactiveColor)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    MainTabView()
}
