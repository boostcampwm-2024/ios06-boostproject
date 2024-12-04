import SwiftUI

enum ButtonType: String {
    case cancel = "취소"
    case confirm = "완료"
    case next = "다음"
    case exportToAppleMusic = "Apple Music 플레이리스트 내보내기"
    case exportToImage = "플레이리스트 이미지로 내보내기"
    case goToAppleMusic = "Apple Music으로 들으러 가기"
    case saveImage = "전체 이미지 저장"
    case shareInstagram = "인스타 공유"
    case needAppleMusicSubcription = "Apple Music 구독 후 이용 가능합니다."
    case didNotSelectPlatform = "플랫폼을 선택해주세요"
    case loginRequired = "로그인하러 가기!"
    case onBoarding = "이해했어요!"
    case startMolio = "몰리오 시작하기!"
}

struct BasicButton: View {
    var type: ButtonType
    var isEnabled: Bool = true
    var action: () -> Void = {}
    
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
        case .cancel, .needAppleMusicSubcription, .didNotSelectPlatform:
            return Color.white.opacity(0.2)
        case .confirm, .next, .exportToAppleMusic, .exportToImage, .saveImage, .shareInstagram, .loginRequired, .onBoarding, .startMolio:
            return Color.mainLighter
        case .goToAppleMusic:
            return Color.background
        }
        
    }
    
    private var textColor: Color {
        switch type {
        case .cancel, .needAppleMusicSubcription, .didNotSelectPlatform:
            return Color.white
        case .confirm, .next, .exportToAppleMusic, .exportToImage, .saveImage, .shareInstagram, .loginRequired, .onBoarding, .startMolio:
            return Color.black
        case .goToAppleMusic:
            return Color.mainLighter
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
