import SwiftUI

struct NickNameTextFieldView: View {
    private let characterLimit: Int
    private var isPossibleInput: Bool
    @Binding var text: String
    
    private var borderColor: Color {
        isPossibleInput ? .background : .red
    }
    
    private var textColor: Color {
        isPossibleInput ? .white : .red
    }
    
    init(
        characterLimit: Int,
        isPossibleInput: Bool,
        text: Binding<String>
    ) {
        self.characterLimit = characterLimit
        self.isPossibleInput = isPossibleInput
        self._text = text
    }
    
    var body: some View {
        VStack(spacing: 7) {
            HStack {
                Text("닉네임")
                    .font(.pretendardRegular(size: 16))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            ZStack {
                Rectangle()
                    .foregroundStyle(.textFieldBackground)
                    .frame(height: 35)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(borderColor, lineWidth: 1)
                    )
                HStack {
                    TextField("", text: $text)
                        .font(.pretendardMedium(size: 13))
                        .foregroundStyle(textColor)
                        .padding(.leading, 12)
                    Text("\(text.count)/\(characterLimit)")
                        .font(.pretendardRegular(size: 12))
                        .foregroundStyle(textColor)
                        .padding(.trailing, 12)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22))
    }
}
