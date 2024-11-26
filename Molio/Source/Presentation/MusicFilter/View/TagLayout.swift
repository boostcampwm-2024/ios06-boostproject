import SwiftUI

/// width 크기를 넘지 않도록 동적으로 태그를 배치하는 레이아웃 컨테이너
struct TagLayout: Layout {
    private let verticalSpacing: CGFloat
    private let horizontalSpacing: CGFloat
    
    init(verticalSpacing: CGFloat = 7, horizontalSpacing: CGFloat = 7) {
        self.verticalSpacing = verticalSpacing
        self.horizontalSpacing = horizontalSpacing
    }
    
    /// 레이아웃 컨테이너 크기를 계산하고 상위 계층으로 보고
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let proposalWidth = proposal.width else { return .zero }
        var totalWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var currentRowWidth: CGFloat = 0
        var maxRowHeight: CGFloat = 0
        var rowCount: Int = 1

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            // 줄바꿈 시 total size 계산
            if currentRowWidth + subviewSize.width + horizontalSpacing > proposalWidth {
                totalWidth = max(totalWidth, currentRowWidth)
                rowCount += 1
                currentRowWidth = 0
            }
            currentRowWidth += subviewSize.width + horizontalSpacing
            maxRowHeight = max(maxRowHeight, subviewSize.height)
        }
        totalWidth = max(totalWidth, currentRowWidth)
        totalHeight = (maxRowHeight + verticalSpacing) * CGFloat(rowCount)

        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    /// 서브뷰를 배치
    /// - `bounds` : 서브뷰가 배치될 컨테이너 뷰의 사각형 영역
    /// - `proposal` : 상위 뷰에서 제안된 크기 (`FilterCellContainer`의 크기)
    /// - `subviews` : 배치할 서브뷰들
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var originX = bounds.minX
        var originY = bounds.minY
        
        for idx in subviews.indices {
            let cell = subviews[idx]
            let cellSize = cell.sizeThatFits(.unspecified)
            
            if originX + cellSize.width + verticalSpacing > bounds.width {
                originX = bounds.minX
                originY += (cellSize.height + verticalSpacing)
            }
            
            cell.place(
                at: CGPoint(x: originX, y: originY),
                anchor: .topLeading,
                proposal: proposal
            )
            
            originX += (cellSize.width + horizontalSpacing)
        }
    }
}

#Preview {
    VStack {
        TagLayout {
            Group {
                FilterTag(content: "팝")
                FilterTag(content: "락")
                FilterTag(content: "재즈")
                FilterTag(content: "일렉트로닉")
                FilterTag(content: "힙합")
                FilterTag(content: "팝")
                FilterTag(content: "일렉트로닉")
                FilterTag(content: "일렉트로닉")
                FilterTag(content: "힙합")
                FilterTag(content: "팝")
                FilterTag(content: "일렉트로닉")
                FilterTag(content: "일렉트로닉")
                FilterTag(content: "힙합")
                FilterTag(content: "팝")
                FilterTag(content: "일렉트로닉")
                FilterTag(content: "일렉트로닉")
            }.background(.red)
        }
        .background(.yellow)
    }
}
