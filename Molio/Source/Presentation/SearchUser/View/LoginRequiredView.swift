import SwiftUI

struct LoginRequiredView: View {
    var didTabLoginRequiredButton: (() -> Void)
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Text(StringLiterals.loginRequired)
                .font(.pretendardSemiBold(size: 24))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            BasicButton(type: .loginRequired) {
                didTabLoginRequiredButton()
            }
            .padding(.horizontal, 20)
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

extension LoginRequiredView {
    enum StringLiterals {
        static let loginRequired: String = "로그인하고\n친구의 플레이리스트를\n구경해보세요!"
    }
}
