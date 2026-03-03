import Foundation

enum UserDefaultsStorage {
    private static let defaults = UserDefaults.standard

    private enum Key {
        static let hasSeenOnboarding = "NovaScotia.hasSeenOnboarding"
        static let savedPlaceIds = "NovaScotia.savedPlaceIds"
        static let savedEventIds = "NovaScotia.savedEventIds"
        static let profileDisplayName = "NovaScotia.profileDisplayName"
        static let profileAvatarIndex = "NovaScotia.profileAvatarIndex"
    }

    static var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasSeenOnboarding) }
        set { defaults.set(newValue, forKey: Key.hasSeenOnboarding) }
    }

    static var savedPlaceIds: [String] {
        get { defaults.stringArray(forKey: Key.savedPlaceIds) ?? [] }
        set { defaults.set(newValue, forKey: Key.savedPlaceIds) }
    }

    static func toggleSavedPlace(id: String) {
        var ids = savedPlaceIds
        if ids.contains(id) {
            ids.removeAll { $0 == id }
        } else {
            ids.append(id)
        }
        savedPlaceIds = ids
    }

    static func isPlaceSaved(id: String) -> Bool {
        savedPlaceIds.contains(id)
    }

    static var savedEventIds: [String] {
        get { defaults.stringArray(forKey: Key.savedEventIds) ?? [] }
        set { defaults.set(newValue, forKey: Key.savedEventIds) }
    }

    static var profileDisplayName: String? {
        get { defaults.string(forKey: Key.profileDisplayName) }
        set { defaults.set(newValue, forKey: Key.profileDisplayName) }
    }

    static var profileAvatarIndex: Int {
        get { defaults.integer(forKey: Key.profileAvatarIndex) }
        set { defaults.set(newValue, forKey: Key.profileAvatarIndex) }
    }

    static func resetAll() {
        savedPlaceIds = []
        savedEventIds = []
        profileDisplayName = nil
        profileAvatarIndex = 0
    }
}
