import SwiftUI

struct SettingView: View {
    private let viewModel: SettingViewModel
    var didTapMyInfoView: (() -> Void)?
    var didTapTermsAndConditionView: (() -> Void)?
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.authMode == .authenticated {
                Button {
                    didTapMyInfoView?()
                } label: {
                    ProfileItemView()
                }
                Color(UIColor(resource: .spacingBackground))
                    .frame(height: 24)
            }
            SettingTextItemView(itemType: .appVersion(viewModel.appVersion))
            Button {
                didTapTermsAndConditionView?()
            } label: {
                SettingTextItemView(itemType: .termsAndCondition)
            }
            Button {
                // TODO: 개인정보 처리방침 페이지 연결
            } label: {
                SettingTextItemView(itemType: .privacyPolicy)
            }
            Color(UIColor(resource: .spacingBackground))
                .frame(height: 24)
            
            switch viewModel.authMode {
            case .authenticated:
                Button {
                    // TODO: 로그 아웃 처리
                } label: {
                    SettingTextItemView(itemType: .logout)
                }
                
                Button {
                    // TODO: 회원 탈퇴 처리
                } label: {
                    SettingTextItemView(itemType: .deleteAccount)
                }
            case .guest:
                Button {
                    // TODO: 로그인 처리
                } label: {
                    SettingTextItemView(itemType: .login)
                }
            }
            Spacer()
        }
        .background(Color.background)
    }
    
}
