enum OnBoardingPage {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    
    var title: String {
        switch self {
        case .one: "나만의 플레이리스트를 만들어볼까요?"
        case .two: "쉽고 빠르게 스와이프로\n내 취향인 노래를 저장해보세요!"
        case .three: "원하는 장르를 선택하여\n나만의 플레이리스트를 만들어보세요!"
        case .four: "몰리오에서 만들 플레이리스트를\n다른 플랫폼으로 내보낼 수 있어요!"
        case .five: "내 친구의 플레이리스트를\n구경할 수 있어요!"
        case .six: "친구의 플레이리스트에서\n마음에 드는 노래를 가져올 수 있어요!"
        case .seven: "Apple Music 권한을 설정하고\n몰리오를 시작해볼까요?"
        }
    }
    
    var subTitle: String? {
        switch self {
        case .one: return "몰리오는 기본 플레이리스트를 제공해요!\n내가 원하는 테마, 분위기에 따라 플리를 생성할 수 있어요."
        case .two: return nil
        case .three: return "플레이리스트에 넣을 음악의 장르를 선택할 수 있어요."
        case .four: return "애플 뮤직을 구독하지 않은 경우에는 플레이리스트를 사진으로 내보낼 수 있어요."
        case .five: return nil
        case .six: return nil
        case .seven: return nil
        }
    }
    
    var image: Image? {
        switch self {
        case .one: Image("onBoardingOne")
        case .two: Image("onBoardingTwo")
        case .three: Image("onBoardingThree")
        case .four: Image("onBoardingFour")
        case .five: Image("onBoardingFive")
        case .six: Image("onBoardingSix")
        case .seven: nil
        }
    }
}
