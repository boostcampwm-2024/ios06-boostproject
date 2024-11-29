import SwiftUI

struct SettingView: View {
    @ObservedObject private var viewModel: SettingViewModel
    @State private var showLogoutAlert = false
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
                    showLogoutAlert = true
                } label: {
                    SettingTextItemView(itemType: .logout)
                }
                .alert("로그아웃", isPresented: $showLogoutAlert) {
                    Button("취소", role: .cancel) { }
                    Button("확인", role: .destructive) {
                        viewModel.logout()
                    }
                } message: {
                    Text("정말 로그아웃 하시겠습니까?")
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
        .animation(.spring(duration: 0.3), value: viewModel.authMode)
        .alert(
            viewModel.alertState.title,
            isPresented: $viewModel.showAlert) {
                Button("확인") { }
            }
    }
}
