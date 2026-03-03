import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)

private let exploreImageNames = ["explore1", "explore2", "explore3", "explore4", "explore5", "explore6", "explore7", "explore8"]

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedFilterIndex: Int?

    var onExploreItemTap: ((Int) -> Void)?

    private var filteredExploreIndices: [Int] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty { return Array(0..<exploreImageNames.count) }
        return (0..<exploreImageNames.count).filter { index in
            (exploreCategoryName(forIndex: index) ?? "").lowercased().contains(query)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            searchBar
            gridContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
    }

    private var header: some View {
        Text("Explore")
            .font(.interSemiBold(size: 28))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(subtitleGray)
            TextField("", text: $searchText, prompt:
                Text("Search places, activities, events...")
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
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private var filterButtons: some View {
        HStack(spacing: 12) {
            ForEach(Array(["Category", "Distance", "Open Now"].enumerated()), id: \.offset) { index, title in
                Button {
                    selectedFilterIndex = selectedFilterIndex == index ? nil : index
                } label: {
                    Text(title)
                        .font(.interMedium(size: 14))
                        .foregroundStyle(.white)
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private var gridContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(filteredExploreIndices, id: \.self) { index in
                    Button {
                        onExploreItemTap?(index)
                    } label: {
                        Image(exploreImageNames[index])
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    ExploreView(onExploreItemTap: { _ in })
}
