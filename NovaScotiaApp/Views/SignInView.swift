import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let accentGold = Color.rgb(246, 196, 69)
private let subtitleGray = Color.rgb(156, 166, 200)

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    var onSuccess: (() -> Void)?
    var onBack: (() -> Void)?

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
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

                Text("Sign In")
                    .font(.interSemiBold(size: 20))
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 56)
            .padding(.bottom, 24)

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

            Button("Sign In") {
                signIn()
            }
            .font(.interSemiBold(size: 16))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.rgb(185, 115, 29))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 24)
            .disabled(isLoading)
            .opacity(isLoading ? 0.7 : 1)
            }
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
    }

    private func signIn() {
        errorMessage = nil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Enter email and password"
            return
        }
        isLoading = true
        Task {
            let result = await AuthService.shared.signIn(email: trimmedEmail, password: password)
            await MainActor.run {
                isLoading = false
                switch result {
                case .success:
                    onSuccess?()
                case .failure(let error):
                    errorMessage = error.errorDescription ?? "Unknown error"
                }
            }
        }
    }
}

#Preview {
    SignInView(onSuccess: { }, onBack: { })
}
