import SwiftUI

struct SettingView: View {
    private let viewModel: SettingViewModel
    var didTapMyInfoView: (() -> Void)?
    var didTapTermsAndConditionView: (() -> Void)?
    var didTapPrivacyPolicyView: (() -> Void)?
    var didTapLoginView: (() -> Void)?
    
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
                didTapPrivacyPolicyView?()
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
                    didTapLoginView?()
                } label: {
                    SettingTextItemView(itemType: .login)
                }
            }
            Spacer()
        }
        .background(Color.background)
    }
    
}
