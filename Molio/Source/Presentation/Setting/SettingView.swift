import SwiftUI

struct SettingView: View {
    var body: some View {
        let authMode: AuthMode = .authenticated
        
        NavigationStack {
            VStack(spacing: 0) {
                if authMode == .authenticated {
                    NavigationLink(destination: MyInfoView(
                        viewModel: MyInfoViewModel(
                            userNickName: "몰리오 올리오", //TODO: 현재 화면의 닉네임 넘겨주기
                            userDescription: "안녕하세요 올리오몰리오입니다.") //TODO: 현재 화면의 설명 넘겨주기
                        )
                    ) {
                        ProfileItemView()
                    }
                    
                    Color(UIColor(resource: .spacingBackground))
                        .frame(height: 24)
                }
                
                NavigationLink(destination: Text("App Version")) {
                    SettingTextItemView(titleText: "앱 버전")
                }
                
                NavigationLink(destination: Text("Terms")) {
                    SettingTextItemView(titleText: "약관 및 개인 정보 처리 동의")
                }
                
                NavigationLink(destination: Text("Privacy Policy")) {
                    SettingTextItemView(titleText: "개인정보 처리방침")
                }
                
                Color(UIColor(resource: .spacingBackground))
                    .frame(height: 24)
                
                switch authMode {
                case .authenticated:
                    NavigationLink(destination: Text("Logout")) {
                        SettingTextItemView(titleText: "로그 아웃")
                    }
                    
                    NavigationLink(destination: Text("Delete Account")) {
                        SettingTextItemView(titleText: "회원 탈퇴")
                    }
                case .guest:
                    NavigationLink(destination: Text("Login")) {
                        SettingTextItemView(titleText: "로그인")
                    }
                }
                Spacer()
            }
            .background(Color.background)
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // TODO: 뒤로가기 action 추가.
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.main)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
