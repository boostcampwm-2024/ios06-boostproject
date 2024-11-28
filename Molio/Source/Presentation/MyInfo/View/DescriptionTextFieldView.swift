import SwiftUI

struct DescriptionTextFieldView: View {
    private let characterLimit: Int
    private var isPossibleInput: Bool
    @Binding var text: String
    
    init(
        characterLimit: Int,
        isPossibleInput: Bool,
        text: Binding<String>
    ) {
        self.characterLimit = characterLimit
        self.isPossibleInput = isPossibleInput
        self._text = text
    }
    
    private var borderColor: Color {
        isPossibleInput ? .background : .red
    }
    
    private var textColor: Color {
        isPossibleInput ? .white : .red
    }
    
    var body: some View {
        VStack(spacing: 7) {
            HStack {
                Text("내 설명")
                    .font(.pretendardRegular(size: 16))
                    .foregroundStyle(.white)
                Spacer()
            }
            VStack(spacing: 4) {
                TextField("", text: $text, axis: .vertical)
                    .font(.pretendardMedium(size: 13))
                    .foregroundStyle(textColor)
                HStack {
                    Spacer()
                    Text("\(text.count)/\(characterLimit)")
                        .font(.pretendardRegular(size: 12))
                        .foregroundStyle(textColor)
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 4, trailing: 10))
            .background(
                Rectangle()
                    .foregroundStyle(.textFieldBackground)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(borderColor, lineWidth: 1)
                    )
            )
        }
        .padding(EdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22))
    }
}
