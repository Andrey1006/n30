import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)
private let accentGold = Color.rgb(246, 196, 69)
private let avatarBlue = Color.rgb(100, 149, 237)
private let logoutRed = Color.rgb(255, 90, 95)

private let profileAvatarEmojis = ["🌊", "🌲", "🗼", "🤿"]

struct ProfileView: View {
    var onLogOut: (() -> Void)?
    var onSavedPlaces: (() -> Void)?
    var onSavedEvents: (() -> Void)?
    var onSettings: (() -> Void)?
    var onHelp: (() -> Void)?

    private var savedPlacesCount: Int { UserDefaultsStorage.savedPlaceIds.count }
    private var savedEventsCount: Int { UserDefaultsStorage.savedEventIds.count }
    private var displayName: String { UserDefaultsStorage.profileDisplayName ?? "Guest" }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                profileCard
                menuSection
                logOutButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Text(profileAvatarEmojis.indices.contains(UserDefaultsStorage.profileAvatarIndex) ? profileAvatarEmojis[UserDefaultsStorage.profileAvatarIndex] : "👤")
                    .font(.system(size: 44))
                    .frame(width: 56, height: 56)
                    .background(cellBorder)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(displayName)
                        .font(.interSemiBold(size: 22))
                        .foregroundStyle(.white)
                    Text("Nova Scotia Island Guide")
                        .font(.interRegular(size: 14))
                        .foregroundStyle(subtitleGray)
                }
                Spacer()
            }

            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(savedPlacesCount)")
                        .font(.interSemiBold(size: 20))
                        .foregroundStyle(accentGold)
                    Text("Saved Places")
                        .font(.interRegular(size: 13))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(savedEventsCount)")
                        .font(.interSemiBold(size: 20))
                        .foregroundStyle(accentGold)
                    Text("Saved Events")
                        .font(.interRegular(size: 13))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cellBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var menuSection: some View {
        VStack(spacing: 12) {
            ProfileMenuItem(
                icon: "bookmark.fill",
                title: "Saved Places",
                value: "\(savedPlacesCount)",
                onTap: { onSavedPlaces?() }
            )
            ProfileMenuItem(
                icon: "calendar",
                title: "Saved Events",
                value: "\(savedEventsCount)",
                onTap: { onSavedEvents?() }
            )
            ProfileMenuItem(
                icon: "gearshape.fill",
                title: "Settings",
                value: nil,
                onTap: { onSettings?() }
            )
            ProfileMenuItem(
                icon: "questionmark.circle.fill",
                title: "Help",
                value: nil,
                onTap: { onHelp?() }
            )
        }
    }

    private var logOutButton: some View {
        Button {
            onLogOut?()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18))
                    .foregroundStyle(logoutRed)
                Text("Log Out")
                    .font(.interSemiBold(size: 16))
                    .foregroundStyle(logoutRed)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(cellBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(logoutRed, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

private struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let value: String?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(accentGold)
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(Color.rgb(18, 24, 48))
                    .cornerRadius(10)

                Text(title)
                    .font(.interMedium(size: 16))
                    .foregroundStyle(.white)

                Spacer()

                if let value = value {
                    Text(value)
                        .font(.interMedium(size: 16))
                        .foregroundStyle(subtitleGray)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
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

#Preview {
    ProfileView(
        onLogOut: { },
        onSavedPlaces: { },
        onSavedEvents: { },
        onSettings: { },
        onHelp: { }
    )
}
