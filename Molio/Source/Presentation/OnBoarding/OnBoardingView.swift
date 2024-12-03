import SwiftUI

struct OnBoardingView: View {
    private let title: String
    private let subTitle: String?
    private let image: Image?
    var didButtonTapped: (() -> Void)?
    
    init(
        title: String,
        subTitle: String? = nil,
        image: Image? = nil
    ) {
        self.title = title
        self.subTitle = subTitle
        self.image = image
    }
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                VStack (alignment: .leading) {
                    Spacer()
                        .frame(height: 10)
                    
                    Text(title)
                        .font(Font.custom("Pretendard", size: 24).weight(.bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let subTitle {
                        Spacer()
                            .frame(height: 24)
                        
                        Text(subTitle)
                            .font(Font.custom("Pretendard", size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }
                }
                
                Spacer()
                    .frame(minHeight: 0)

                if let image {
                    image
                }
                
                Spacer()
                    .frame(minHeight: 0)

                BasicButton(type: .onBoarding) {
                    didButtonTapped?()
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 22)
        }
    }
}

#Preview {
    OnBoardingView(
        title: "나만의 플레이리스트를 만들어볼까요?",
        subTitle: """
                      몰리오는 기본 플레이리스트를 제공해요!
                      내가 원하는 테마, 분위기에 따라 플리를 생성할 수 있어요.
                      """,
        image: Image("onBoardingPlaylist")
    )
}
#Preview {
    OnBoardingView(
        title: """
        쉽고 빠르게 스와이프로
        내 취향인 노래를 저장해보세요!
        """,
        image: Image("onBoardingSwipe")
    )
}
#Preview {
    OnBoardingView(
        title: """
        몰리오에서 만들 플레이리스트를
        다른 플랫폼으로 내보낼 수 있어요!
        """,
        subTitle: """
                      애플 뮤직을 구독하지 않은 경우에는
                      플레이리스트를 사진으로 내보낼 수 있어요.
                      """,
        image: Image("onBoardingExport")
    )
}

#Preview {
    OnBoardingView(
        title: """
        내 친구의 플레이리스트를
        구경할 수 있어요!
        """,
        image: Image("onBoardingCommunity")
    )
}

#Preview {
    OnBoardingView(
        title: """
        친구의 플레이리스트에서
        마음에 드는 노래를 가져올 수 있어요!
        """,
        image: Image("onBoardingFriendPlaylist")
    )
}
