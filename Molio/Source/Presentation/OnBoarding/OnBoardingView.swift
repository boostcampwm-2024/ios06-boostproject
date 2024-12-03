import SwiftUI

struct OnBoardingView: View {
    private let page: OnBoardingPage
    var didButtonTapped: (() -> Void)?
    
    @State var isAppleMusicPermissonAllowed: Bool = false
    
    init(page: OnBoardingPage) {
        self.page = page
    }
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text.molioBold(page.title, size: 24)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let subTitle = page.subTitle {
                        Text.molioMedium(subTitle, size: 16)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
                
                if let image = page.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    appleMusicPermisonRequestView()
                }
                
                Spacer()
                
                switch page {
                case .seven:
                    BasicButton(type: .startMolio, isEnabled: isAppleMusicPermissonAllowed) {
                        didButtonTapped?()
                    }
                default:
                    BasicButton(type: .onBoarding) {
                        didButtonTapped?()
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 15)
        }
    }
    
    func appleMusicPermisonRequestView() -> some View {
        VStack(alignment: .leading) {
            Text.molioMedium("필수 권한", size: 16)
                .foregroundStyle(.gray)
            HStack(alignment: .center) {
                Image("appleMusicLogo")
                    .resizable()
                    .frame(width: 49, height: 49)
                Text.molioSemiBold("미디어 및 Apple Music", size: 18)
                    .fixedSize(horizontal: true, vertical: false)
                Toggle(isOn: $isAppleMusicPermissonAllowed) {
                    Text("Request Apple Music Permission")
                }
                .labelsHidden()
            }
            .padding(.vertical, 45)
            .padding(.horizontal, 27)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    OnBoardingView(page: .seven)
}
