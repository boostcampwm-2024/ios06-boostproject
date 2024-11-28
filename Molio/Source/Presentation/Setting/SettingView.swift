import SwiftUI

struct SettingView: View {
    let authMode: AuthMode = .authenticated
    var didTapMyInfoView: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            if authMode == .authenticated {
                Button {
                    didTapMyInfoView?()
                } label: {
                    ProfileItemView()
                }
                
                Color(UIColor(resource: .spacingBackground))
                    .frame(height: 24)
            }
            
            Button {
                // TODO: 앱 버전 페이지 연결
            } label: {
                SettingTextItemView(titleText: "앱 버전")
            }
            
            Button {
                // TODO: 약관 및 개인 정보 처리 동의 페이지 연결
            } label: {
                SettingTextItemView(titleText: "약관 및 개인 정보 처리 동의")
            }
            
            Button {
                // TODO: 개인정보 처리방침 페이지 연결
            } label: {
                SettingTextItemView(titleText: "개인정보 처리방침")
            }
            
            Color(UIColor(resource: .spacingBackground))
                .frame(height: 24)
            
            switch authMode {
            case .authenticated:
                Button {
                    // TODO: 로그 아웃 처리
                } label: {
                    SettingTextItemView(titleText: "로그 아웃")
                }
                
                Button {
                    // TODO: 회원 탈퇴 처리
                } label: {
                    SettingTextItemView(titleText: "회원 탈퇴")
                }
            case .guest:
                Button {
                    // TODO: 로그인 처리
                } label: {
                    SettingTextItemView(titleText: "로그인")
                }
            }
            Spacer()
        }
        .background(Color.background)
    }
    
}

#Preview {
    SettingView()
}
