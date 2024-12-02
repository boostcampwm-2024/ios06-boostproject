import SwiftUI

struct SettingTextItemView: View {
    private let itemType: SettingItemType
    
    init(itemType: SettingItemType) {
        self.itemType = itemType
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(itemType.text)
                    .font(.pretendardRegular(size: 16))
                    .foregroundStyle(.white)
                    .padding(.leading, 16)
                    .padding(.top, 11)
                    .padding(.bottom, 11)
                
                Spacer()
                
                if case let .appVersion(version) = itemType {
                    Text(version)
                        .font(.pretendardRegular(size: 16))
                        .foregroundStyle(.gray)
                        .padding(.trailing, 16)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding(.trailing, 16)
                }
            }
            if !itemType.isLastItem {
                Divider()
                    .background(Color(UIColor.darkGray))
                    .padding(.leading, 16)
                    .padding(.bottom, 1)
            }
        }
        .background(Color(uiColor: UIColor(resource: .background)))
    }
    
    enum SettingItemType {
        case appVersion(String)
        case termsAndCondition
        case privacyPolicy
        case logout
        case login
        case deleteAccount
        
        var text: String {
            switch self {
            case .appVersion:
                "앱 버전"
            case .termsAndCondition:
                "약관 및 개인 정보 처리 동의"
            case .privacyPolicy:
                "개인정보 처리방침"
            case .logout:
                "로그 아웃"
            case .login:
                "로그인"
            case .deleteAccount:
                "회원 탈퇴"
            }
        }
        
        var isLastItem: Bool {
            switch self {
            case .appVersion, .termsAndCondition, .logout:
                false
            case .privacyPolicy, .deleteAccount, .login:
                true
            }
        }
    }
}
