import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize,
                      subviews: Subviews,
                      cache: inout ()) -> CGSize {

        let containerWidth = proposal.width ?? .infinity
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }

        return layout(sizes: sizes,
                      spacing: spacing,
                      containerWidth: containerWidth).size
    }

    func placeSubviews(in bounds: CGRect,
                       proposal: ProposedViewSize,
                       subviews: Subviews,
                       cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes,
                             spacing: spacing,
                             containerWidth: bounds.width).offsets

        for (offset, subview) in zip(offsets, subviews) {
            subview.place(
                at: CGPoint(x: offset.x + bounds.minX, y: offset.y + bounds.minY),
                proposal: .unspecified
            )
        }
    }

    // MARK: - Layout Calculation Helper
    private func layout(sizes: [CGSize],
                        spacing: CGFloat,
                        containerWidth: CGFloat) -> (size: CGSize, offsets: [CGPoint]) {

        var offsets: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for size in sizes {
            if x + size.width > containerWidth {
                x = 0
                y += lineHeight + spacing
                totalHeight += lineHeight + spacing
                lineHeight = 0
            }

            offsets.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }

        totalHeight += lineHeight

        return (
            CGSize(width: containerWidth, height: totalHeight),
            offsets
        )
    }
}
