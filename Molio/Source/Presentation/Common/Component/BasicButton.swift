import SwiftUI

enum ButtonType: String {
    case cancel = "취소"
    case confirm = "완료"
    case saveImage = "이미지 저장"
    case shareInstagram = "인스타 공유"
}

struct BasicButton: View {
    var type: ButtonType
    var isEnabled: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.headline)
                .foregroundColor(textColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
    
    // 버튼의 배경색을 타입에 따라 변경
    private var backgroundColor: Color {
        switch type {
        case .cancel:
            return Color.white.opacity(0.2)
        case .confirm:
            return Color.mainLighter
        case .saveImage:
            return Color.mainLighter
        case .shareInstagram:
            return Color.mainLighter
        }
        
    }
    
    private var textColor: Color {
        switch type {
        case .cancel:
            return Color.white
        case .confirm:
            return Color.black
        case .saveImage:
            return Color.black
        case .shareInstagram:
            return Color.black
        }
    }
}

#Preview {
    VStack {
        BasicButton(type: .cancel) {
            print("취소 버튼 눌림")
        }.padding()
        
        BasicButton(type: .confirm) {
            print("완료 버튼 눌림")
        }.padding()
    }.background(Color.background)
}
