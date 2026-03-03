import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)
private let accentGold = Color.rgb(246, 196, 69)
private let resetRed = Color.rgb(255, 90, 95)

struct SettingsView: View {
    @State private var pushNotificationsOn = true
    @State private var locationServicesOn = false
    @State private var showResetAlert = false
    @State private var showDeleteAccountAlert = false
    @State private var showDeleteErrorAlert = false
    @State private var deleteAccountError: String?
    @State private var isDeletingAccount = false

    var onBack: (() -> Void)?
    var onResetData: (() -> Void)?
    var onLogOut: (() -> Void)?
    var onDeleteAccount: (() -> Void)?

    var body: some View {
        VStack(spacing: 24) {
            header
            contentScroll
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
        .alert("Reset data?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                UserDefaultsStorage.resetAll()
                onResetData?()
            }
        } message: {
            Text("Saved places, events, and profile data will be cleared. This cannot be undone.")
        }
        .alert("Delete account?", isPresented: $showDeleteAccountAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                performDeleteAccount()
            }
        } message: {
            Text("Your account and all associated data will be permanently deleted. This cannot be undone.")
        }
        .alert("Error", isPresented: $showDeleteErrorAlert) {
            Button("OK") { showDeleteErrorAlert = false; deleteAccountError = nil }
        } message: {
            Text(deleteAccountError ?? "Something went wrong")
        }
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

            Text("Settings")
                .font(.interSemiBold(size: 24))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var contentScroll: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                preferencesSection
                dataSection
                accountSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PREFERENCES")
                .font(.interMedium(size: 12))
                .foregroundStyle(subtitleGray)
                .tracking(0.5)

            VStack(spacing: 8) {
                settingsRow(title: "Push Notifications") {
                    Toggle("", isOn: $pushNotificationsOn)
                        .labelsHidden()
                        .tint(accentGold)
                }

                settingsRow(title: "Location Services") {
                    Toggle("", isOn: $locationServicesOn)
                        .labelsHidden()
                        .tint(accentGold)
                }
            }
        }
    }

    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DATA")
                .font(.interMedium(size: 12))
                .foregroundStyle(subtitleGray)
                .tracking(0.5)

            Button {
                showResetAlert = true
            } label: {
                Text("Reset data")
                    .font(.interSemiBold(size: 16))
                    .foregroundStyle(resetRed)
                    .frame(maxWidth: .infinity)
                    .padding(16)
            }
            .buttonStyle(.plain)
            .background(cellBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(resetRed, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ACCOUNT")
                .font(.interMedium(size: 12))
                .foregroundStyle(subtitleGray)
                .tracking(0.5)

            Button {
                onLogOut?()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 18))
                        .foregroundStyle(resetRed)
                    Text("Log Out")
                        .font(.interSemiBold(size: 16))
                        .foregroundStyle(resetRed)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
            }
            .buttonStyle(.plain)
            .disabled(isDeletingAccount)
            .background(cellBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(resetRed, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button {
                showDeleteAccountAlert = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundStyle(resetRed)
                    Text("Delete account")
                        .font(.interSemiBold(size: 16))
                        .foregroundStyle(resetRed)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
            }
            .buttonStyle(.plain)
            .disabled(isDeletingAccount)
            .background(cellBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(resetRed, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func performDeleteAccount() {
        deleteAccountError = nil
        isDeletingAccount = true
        Task {
            let result = await AuthService.shared.deleteAccount()
            await MainActor.run {
                isDeletingAccount = false
                switch result {
                case .success:
                    onDeleteAccount?()
                case .failure(let error):
                    deleteAccountError = error.errorDescription ?? "Failed to delete account"
                    showDeleteErrorAlert = true
                }
            }
        }
    }

    private func settingsRow<Content: View>(title: String, @ViewBuilder trailing: () -> Content) -> some View {
        HStack {
            Text(title)
                .font(.interMedium(size: 16))
                .foregroundStyle(.white)
            Spacer()
            trailing()
        }
        .padding(16)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cellBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SettingsView(
        onBack: { },
        onResetData: { },
        onLogOut: { },
        onDeleteAccount: { }
    )
}
