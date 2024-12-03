import SwiftUI

struct OnBoardingView: View {
    private let page: OnBoardingPage
    var didButtonTapped: (() -> Void)?
    
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
                }
                
                Spacer()
                
                BasicButton(type: .onBoarding) {
                    didButtonTapped?()
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 15)
        }
    }
}

#Preview {
    OnBoardingView(page: .one)
}
#Preview {
    OnBoardingView(page: .two)
}
#Preview {
    OnBoardingView(page: .three)
}
#Preview {
    OnBoardingView(page: .four)
}
#Preview {
    OnBoardingView(page: .five)
}
#Preview {
    OnBoardingView(page: .six)
}
