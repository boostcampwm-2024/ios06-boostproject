import SwiftUI

struct FollowRelationButton: View {
    var type: FollowRelationType
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            Text.molioSemiBold(type.rawValue, size: 13)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
        }
    }
    
    // 버튼의 배경색을 타입에 따라 변경
    private var backgroundColor: Color {
        switch type {
        case .following:
            return Color.white.opacity(0.2)
        case .unfollowing:
            return Color.mainLighter
        }
        
    }
    
    private var textColor: Color {
        switch type {
        case .following:
            return Color.white
        case .unfollowing:
            return Color.black
        }
    }
}
