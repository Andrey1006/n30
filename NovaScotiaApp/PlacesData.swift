func place(byId id: String) -> PlaceItem? {
    allPlaceItems.first { $0.id == id }
}

var allPlaceItems: [PlaceItem] {
    Array(allPlaceItemsById.values).sorted { $0.title < $1.title }
}

private let allPlaceItemsById: [String: PlaceItem] = [
    "1": PlaceItem(id: "1", title: "Emerald Cove Beach", imageName: "EmeraldCoveBeach", category: "Beaches", rating: "4.7", distance: "1.9 km", description: "Wide sand and gentle waves make this a relaxing spot for swimming and picnics. The atmosphere is calm, especially on weekdays."),
    "2": PlaceItem(id: "2", title: "Harbor Lights Café", imageName: "HarborLightsCafe", category: "Food & Cafes", rating: "4.8", distance: "1.2 km", description: "Fresh seafood classics and warm drinks with a view of the harbor. A perfect lunch stop after the beach."),
    "3": PlaceItem(id: "3", title: "Nova Scotia Casino", imageName: "NovaScotiaCasino", category: "Casino & Entertainment", rating: "4.6", distance: "2.2 km", description: "An entertainment hub with table games, slots, and scheduled live music. A straightforward option for evening plans."),
    "4": PlaceItem(id: "4", title: "Kelp Forest Bay", imageName: "KelpForestBay", category: "Diving", rating: "4.6", distance: "5.4 km", description: "A sheltered bay known for dramatic kelp scenery and gentle conditions. Perfect for first dives and relaxed snorkeling."),
    "5": PlaceItem(id: "5", title: "Coastal Wind Path", imageName: "CoastalWindPath", category: "Scenic Trails", rating: "4.7", distance: "5.2 km", description: "An easy coastal path with frequent viewpoints and benches. Great for casual walkers and quick scenic breaks."),
    "6": PlaceItem(id: "6", title: "Sunset Cliffs Point", imageName: "SunsetCliffsPoint", category: "Scenic Viewpoints", rating: "4.8", distance: "3.6 km", description: "A dramatic ocean overlook where waves crash against rugged cliffs. Popular for sunset watching and quiet evening walks. The wide horizon makes it a favorite spot for photographers."),
    "7": PlaceItem(id: "7", title: "Seagrass Lagoon", imageName: "SeagrassLagoon", category: "Snorkeling", rating: "4.5", distance: "2.8 km", description: "A shallow lagoon filled with seagrass beds and small marine life. Calm and clear water makes it ideal for beginners exploring underwater ecosystems."),
    "8": PlaceItem(id: "8", title: "Lighthouse Bluff Trail", imageName: "LighthouseBluffTrail", category: "Scenic Trails", rating: "4.7", distance: "4.1 km", description: "A short trail leading to a historic lighthouse on a rocky bluff. Along the way, scenic viewpoints reveal the coastline and passing boats."),
    "9": PlaceItem(id: "9", title: "Tidepool Discovery Beach", imageName: "TidepoolDiscoveryBeach", category: "Beaches", rating: "4.6", distance: "2.3 km", description: "A rocky shoreline known for its colorful tide pools revealed during low tide. Families and nature lovers come here to explore tiny marine creatures and coastal formations.")
]

func placeDetailData(for placeId: String) -> PlaceDetailData? {
    placeDetailDataByPlaceId[placeId]
}

private let placeDetailDataByPlaceId: [String: PlaceDetailData] = [
    "1": PlaceDetailData(
        highlights: ["Family-friendly", "Calm water", "Picnic area", "Easy access"],
        whatToDo: ["Swim", "Beach walk", "Picnic lunch", "Sunset photos"],
        tips: ["Arrive before noon", "Bring a light jacket", "Use sunscreen"]
    ),
    "4": PlaceDetailData(
        highlights: ["Beginner-friendly", "Snorkel-friendly", "Shore entry", "Calm water"],
        whatToDo: ["Intro dive", "Kelp forest swim", "Snorkel route", "Marine life watch"],
        tips: ["Summer is calmest", "Wear gloves for comfort", "Follow marked entry points"]
    ),
    "2": PlaceDetailData(
        highlights: ["Seafood", "Harbor view", "Cozy vibe", "Local favorite"],
        whatToDo: ["Try chowder", "Coffee break", "Dessert", "Harbor stroll after"],
        tips: ["Peak at 12-2pm", "Ask for daily special", "Window seats are best"]
    ),
    "5": PlaceDetailData(
        highlights: ["Beginner-friendly", "Quick access", "Benches", "Coastal views"],
        whatToDo: ["Walk & talk", "Scenic stops", "Mini photo tour", "Stretch break"],
        tips: ["Bring a windbreaker", "Early morning is quietest", "Wear comfy shoes"]
    ),
    "3": PlaceDetailData(
        highlights: ["Live shows", "Dining", "Casino floor", "Evening events"],
        whatToDo: ["Show night", "Dinner", "Casino floor", "Lounge music"],
        tips: ["Check event schedule", "Go after dinner", "Weekends are busiest"]
    ),
    "6": PlaceDetailData(
        highlights: ["Cliff views", "Sunset spot", "Photo-friendly", "Quiet area"],
        whatToDo: ["Watch the sunset", "Ocean photography", "Short cliff walk", "Relax on benches"],
        tips: ["Arrive 30 minutes before sunset", "Stay behind safety railings", "Bring a light jacket"]
    ),
    "7": PlaceDetailData(
        highlights: ["Shallow water", "Beginner-friendly", "Marine life", "Calm lagoon"],
        whatToDo: ["Snorkel the lagoon", "Spot small fish", "Float and relax", "Underwater photos"],
        tips: ["Best visibility in the morning", "Avoid stirring the sand", "Use reef-safe sunscreen"]
    ),
    "8": PlaceDetailData(
        highlights: ["Historic lighthouse", "Ocean views", "Easy trail", "Photo spots"],
        whatToDo: ["Walk to the lighthouse", "Coastal photography", "Watch boats pass", "Picnic at viewpoints"],
        tips: ["Wind can be strong", "Wear comfortable shoes", "Sunset views are best"]
    ),
    "9": PlaceDetailData(
        highlights: ["Tide pools", "Family-friendly", "Marine discovery", "Rocky shore"],
        whatToDo: ["Explore tide pools", "Spot starfish and crabs", "Coastal photography", "Beach walk"],
        tips: ["Visit during low tide", "Wear water shoes", "Watch your step on wet rocks"]
    )
]
