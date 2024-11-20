import SwiftUI

enum ButtonType: String {
    case cancel = "취소"
    case confirm = "완료"
}

struct BasicButton: View {
    private var type: ButtonType
    private var action: () -> Void
    
    init(type: ButtonType, action: @escaping () -> Void) {
        self.type = type
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.headline)
                .foregroundColor(textColor)
                .padding()
                .frame(maxWidth: .infinity) // 버튼이 화면 전체 넓이에 맞게
                .background(backgroundColor)
                .cornerRadius(10)
        }
    }
    
    // 버튼의 배경색을 타입에 따라 변경
    private var backgroundColor: Color {
        switch type {
        case .cancel:
            return Color.white.opacity(0.2)
        case .confirm:
            return Color.mainLighter
        }
    }
    
    private var textColor: Color {
        switch type {
        case .cancel:
            return Color.white
        case .confirm:
            return Color.black
        }
    }
}

#Preview {
    VStack {
        BasicButton(type: .cancel){
            print("취소 버튼 눌림")
        }.padding()
        
        BasicButton(type: .confirm) {
            print("완료 버튼 눌림")
        }.padding()
    }.background(Color.background)
}
