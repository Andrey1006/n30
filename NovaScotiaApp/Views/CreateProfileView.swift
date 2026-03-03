import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let accentGold = Color.rgb(246, 196, 69)
private let subtitleGray = Color.rgb(156, 166, 200)

private let avatarEmojis = ["🌊", "🌲", "🗼", "🤿"]

struct CreateProfileView: View {
    @State private var selectedAvatarIndex = 0
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    var onCreateProfile: (() -> Void)?
    var onContinueAsGuest: (() -> Void)?
    var onSignIn: (() -> Void)?

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Create your profile")
                .font(.interSemiBold(size: 28))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)

            Text("Pick an avatar and create a simple prototype login.")
                .font(.interRegular(size: 15))
                .foregroundStyle(subtitleGray)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

            Text("Choose Avatar")
                .font(.interMedium(size: 13))
                .foregroundStyle(subtitleGray)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)

            HStack(spacing: 16) {
                ForEach(Array(avatarEmojis.enumerated()), id: \.offset) { index, emoji in
                    Button {
                        selectedAvatarIndex = index
                    } label: {
                        Text(emoji)
                            .font(.system(size: 32))
                            .frame(width: 72, height: 72)
                            .background(index == selectedAvatarIndex ? cellBorder : cellBackground)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            Text("Name")
                .font(.interMedium(size: 13))
                .foregroundStyle(subtitleGray)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)

            TextField("Enter your name", text: $name, prompt:
                Text("Enter your name")
                    .font(.interRegular(size: 16))
                    .foregroundColor(subtitleGray)
            )
            .font(.interRegular(size: 16))
            .foregroundStyle(.white)
            .textContentType(.name)
            .autocapitalization(.words)
            .padding(16)
            .background(cellBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(cellBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            Text("Email")
                .font(.interMedium(size: 13))
                .foregroundStyle(subtitleGray)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)

            TextField("Enter email", text: $email, prompt:
                Text("Enter email")
                    .font(.interRegular(size: 16))
                    .foregroundColor(subtitleGray)
            )
            .font(.interRegular(size: 16))
            .foregroundStyle(.white)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .padding(16)
            .background(cellBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(cellBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            Text("Password")
                .font(.interMedium(size: 13))
                .foregroundStyle(subtitleGray)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)

            SecureField("", text: $password, prompt:
                            Text("Enter password")
                                .font(.interRegular(size: 16))
                                .foregroundColor(subtitleGray)
            )
            .font(.interRegular(size: 16))
            .foregroundStyle(.white)
            .padding(16)
            .background(cellBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(cellBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.interRegular(size: 14))
                    .foregroundStyle(.red)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
            }

            Button("Create Profile") {
                createProfile()
            }
            .disabled(isLoading)
            .opacity(isLoading ? 0.7 : 1)
            .font(.interSemiBold(size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.rgb(185, 115, 29))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

            Button("Continue as Guest") {
                continueAsGuest()
            }
            .disabled(isLoading)
            .opacity(isLoading ? 0.7 : 1)
            .font(.interSemiBold(size: 16))
            .foregroundStyle(accentGold)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(cellBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(cellBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 24)
            .padding(.bottom, 32)

            HStack(spacing: 0) {
                Text("Already have a profile? ")
                    .font(.interMedium(size: 14))
                    .foregroundStyle(accentGold)
                Button("Sign in") {
                    onSignIn?()
                }
                .font(.interMedium(size: 14))
                .foregroundStyle(accentGold)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 40)
            }
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
    }

    private func createProfile() {
        errorMessage = nil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Enter email and password"
            return
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        isLoading = true
        Task {
            let result: AuthResult
            if AuthService.shared.isAnonymous {
                result = await AuthService.shared.linkAnonymousAccount(email: trimmedEmail, password: password)
            } else {
                result = await AuthService.shared.register(email: trimmedEmail, password: password)
            }
            await MainActor.run {
                isLoading = false
                switch result {
                case .success:
                    UserDefaultsStorage.profileDisplayName = name.isEmpty ? nil : name
                    UserDefaultsStorage.profileAvatarIndex = selectedAvatarIndex
                    onCreateProfile?()
                case .failure(let error):
                    errorMessage = error.errorDescription ?? "Unknown error"
                }
            }
        }
    }

    private func continueAsGuest() {
        errorMessage = nil
        isLoading = true
        Task {
            let result = await AuthService.shared.signInAnonymously()
            await MainActor.run {
                isLoading = false
                switch result {
                case .success:
                    UserDefaultsStorage.profileDisplayName = name.isEmpty ? nil : name
                    UserDefaultsStorage.profileAvatarIndex = selectedAvatarIndex
                    onContinueAsGuest?()
                case .failure(let error):
                    errorMessage = error.errorDescription ?? "Unknown error"
                }
            }
        }
    }
}

#Preview {
    CreateProfileView(
        onCreateProfile: { },
        onContinueAsGuest: { },
        onSignIn: { }
    )
}
