import AuthenticationServices
import SwiftUI

struct SettingView: View {
    @ObservedObject private var viewModel: SettingViewModel
    @State private var showLogoutAlert = false
    @State private var showDeleteAccountAlert = false
    var didTapMyInfoView: (() -> Void)?
    var didTapTermsAndConditionView: (() -> Void)?
    var didTapPrivacyPolicyView: (() -> Void)?
    var didTapLoginView: (() -> Void)?
    var didTapDeleteAccountView: (() -> Void)?
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLogin {
                Button {
                    didTapMyInfoView?()
                } label: {
                    ProfileItemView(molioUser: $viewModel.molioUser)
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
            
            if viewModel.isLogin {
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
                    showDeleteAccountAlert = true
                } label: {
                    SettingTextItemView(itemType: .deleteAccount)
                }
                .alert("계정탈퇴", isPresented: $showDeleteAccountAlert) {
                    Button("취소", role: .cancel) { }
                    Button("확인", role: .destructive) {
                        viewModel.deleteAccount()
                    }
                } message: {
                    Text("정말 계정탈퇴 하시겠습니까?")
                }
            } else {
                Button {
                    didTapLoginView?()
                } label: {
                    SettingTextItemView(itemType: .login)
                }
            }
            Spacer()
        }
        .background(Color.background)
        .animation(.spring(duration: 0.3), value: viewModel.isLogin)
        .onAppear {
            Task {
                try await viewModel.fetchProfile()
            }
        }
        .alert(
            viewModel.alertState.title,
            isPresented: $viewModel.showAlert) {
                Button("확인") { 
                    if viewModel.alertState == .successDeleteAccount {
                        didTapDeleteAccountView?()
                    }
                }
            }
    }
}
