import SwiftUI

private let screenBackground = Color.rgb(7, 7, 19)
private let cellBackground = Color.rgb(13, 14, 34)
private let cellBorder = Color.rgb(27, 34, 59)
private let subtitleGray = Color.rgb(156, 166, 200)
private let accentGold = Color.rgb(246, 196, 69)
private let accentOrange = Color.rgb(185, 115, 29)
private let pillBackground = Color.rgb(37, 45, 75)

struct PlaceDetailData {
    let highlights: [String]
    let whatToDo: [String]
    let tips: [String]
}

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let place: PlaceItem
    let detail: PlaceDetailData
    var isBookmarked: Bool = false
    var onBack: (() -> Void)?
    var onBookmark: (() -> Void)?
    var onOpenInMap: (() -> Void)?

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerImage
                    contentBody
                        .padding(.bottom, 100)
                }
            }
            .ignoresSafeArea(edges: .top)

            bottomButtons
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(screenBackground)
        .navigationBarBackButtonHidden(true)
    }

    private var headerImage: some View {
        ZStack(alignment: .top) {
            Image(place.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 280)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.4), .clear],
                startPoint: .top,
                endPoint: .center
            )

            HStack {
                Button {
                    dismiss()
                    onBack?()
                } label: {
                    Image("backButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    onBookmark?()
                } label: {
                    Image("favoriteButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 56)
        }
    }

    private var contentBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(place.title)
                .font(.interSemiBold(size: 24))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.top, 20)

            HStack(spacing: 12) {
                Text(place.category)
                    .font(.interMedium(size: 13))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(pillBackground)
                    .clipShape(Capsule())

                Image(systemName: "star.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(accentGold)
                Text(place.rating)
                    .font(.interRegular(size: 14))
                    .foregroundStyle(.white)

                Image(systemName: "mappin")
                    .font(.system(size: 14))
                    .foregroundStyle(subtitleGray)
                Text(place.distance)
                    .font(.interRegular(size: 14))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)

            Text(place.description)
                .font(.interRegular(size: 16))
                .foregroundStyle(subtitleGray)
                .lineSpacing(4)
                .padding(.horizontal, 20)

            sectionHeading("Highlights")
            highlightsRow
                .padding(.horizontal, 20)

            sectionHeading("What to do")
            bulletList(items: detail.whatToDo, bulletColor: accentGold)
                .padding(.horizontal, 20)

            sectionHeading("Tips")
            bulletList(items: detail.tips, systemImage: "lightbulb.fill")
                .padding(.horizontal, 20)
        }
    }

    private func sectionHeading(_ title: String) -> some View {
        Text(title)
            .font(.interSemiBold(size: 18))
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.top, 8)
    }

    private var highlightsRow: some View {
        FlowLayout(spacing: 8) {
            ForEach(detail.highlights, id: \.self) { text in
                Text(text)
                    .font(.interMedium(size: 13))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(pillBackground)
                    .clipShape(Capsule())
            }
        }
    }

    private func bulletList(items: [String], bulletColor: Color? = nil, systemImage: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    if let systemImage = systemImage {
                        Image(systemName: systemImage)
                            .font(.system(size: 12))
                            .foregroundStyle(accentGold)
                    } else if let color = bulletColor {
                        Circle()
                            .fill(color)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                    }
                    Text(item)
                        .font(.interRegular(size: 15))
                        .foregroundStyle(subtitleGray)
                }
            }
        }
        .padding(.top, 4)
    }

    private var bottomButtons: some View {
        Button("Open in Map") {
            onOpenInMap?()
        }
        .font(.interSemiBold(size: 16))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(cellBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(cellBorder, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
        .padding(.top, 12)
        .background(
            LinearGradient(
                colors: [screenBackground.opacity(0), screenBackground],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var frames: [CGRect] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        let totalHeight = y + rowHeight
        return (CGSize(width: maxWidth, height: totalHeight), frames)
    }
}

#Preview {
    PlaceDetailView(
        place: PlaceItem(
            id: "1",
            title: "Emerald Cove Beach",
            imageName: "EmeraldCoveBeach",
            category: "Beaches",
            rating: "4.7",
            distance: "1.9 km",
            description: "Wide sand and gentle waves make this a relaxing spot for swimming and picnics. The atmosphere is calm, especially on weekdays."
        ),
        detail: PlaceDetailData(
            highlights: ["Family-friendly", "Calm water", "Picnic area", "Easy access"],
            whatToDo: ["Swim", "Beach walk", "Picnic lunch", "Sunset photos"],
            tips: ["Arrive before noon", "Bring a light jacket", "Use sunscreen"]
        ),
        onBack: { },
        onBookmark: { },
        onOpenInMap: { }
    )
}
