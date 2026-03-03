import SwiftUI

enum AppPhase {
    case loading
    case onboarding
    case createProfile
    case signIn
    case main
}

struct AppRootView: View {
    @State private var appPhase: AppPhase = .loading

    var body: some View {
        Group {
            switch appPhase {
            case .loading:
                loadingView
            case .onboarding:
                OnboardingView(
                    onComplete: { goToCreateProfile() },
                    onSkip: { goToCreateProfile() }
                )
            case .createProfile:
                CreateProfileView(
                    onCreateProfile: { goToMain() },
                    onContinueAsGuest: { goToMain() },
                    onSignIn: { appPhase = .signIn }
                )
            case .signIn:
                SignInView(
                    onSuccess: { goToMain() },
                    onBack: { appPhase = .createProfile }
                )
            case .main:
                MainTabView(onLogOut: { performLogOut() })
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appPhase)
        .onAppear { resolveInitialPhase() }
    }

    private var loadingView: some View {
        ZStack {
            Color.rgb(7, 7, 19)
                .ignoresSafeArea()
            ProgressView()
                .tint(.white)
        }
    }

    private func resolveInitialPhase() {
        if !UserDefaultsStorage.hasSeenOnboarding {
            appPhase = .onboarding
            return
        }
        if AuthService.shared.currentUser != nil {
            appPhase = .main
        } else {
            appPhase = .createProfile
        }
    }

    private func goToCreateProfile() {
        UserDefaultsStorage.hasSeenOnboarding = true
        appPhase = .createProfile
    }

    private func goToMain() {
        appPhase = .main
    }

    private func performLogOut() {
        Task {
            await AuthService.shared.signOut()
            await MainActor.run {
                appPhase = .createProfile
            }
        }
    }
}
