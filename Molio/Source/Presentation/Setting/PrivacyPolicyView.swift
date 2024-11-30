import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                sectionView(
                    title: "1. 수집하는 개인정보 항목",
                    content: """
                                • 필수항목
                                  - 이메일 주소
                                
                                • 자동 수집항목
                                  - 서비스 이용기록
                                  - 기기 정보
                                  - IP 주소
                                """
                )
                sectionView(
                    title: "2. 개인정보의 수집 및 이용목적",
                    content: """
                                • 회원 가입 및 관리
                                  - 회원제 서비스 이용에 따른 본인확인
                                  - 서비스 부정이용 방지
                                  - 고지사항 전달
                                
                                • 서비스 제공 및 운영
                                  - 서비스 제공 및 운영
                                  - 맞춤 서비스 제공
                                """
                )
                
                sectionView(
                    title: "3. 개인정보의 보유 및 이용기간",
                    content: """
                                • 회원 탈퇴 시까지 보유
                                • 단, 관계법령에 따라 필요한 경우 해당 기간까지 보유
                                  - 소비자 불만 또는 분쟁처리 기록: 3년
                                """
                )
                
                sectionView(
                    title: "4. 개인정보의 파기",
                    content: """
                                회원 탈퇴 시 지체 없이 파기됩니다.
                                다만, 관계법령에 의해 보관해야 하는 정보는 법령이 정한 기간 동안 보관 후 파기됩니다.
                                """
                )
                
                sectionView(
                    title: "5. 이용자의 권리",
                    content: """
                                이용자는 언제든지 개인정보를 조회하거나 수정할 수 있으며, 회원탈퇴를 통해 개인정보의 수집 및 이용에 대한 동의를 철회할 수 있습니다.
                                """
                )
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.background)
    }

    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(content)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
                .frame(height: 20)
        }
        .padding()
    }
}

#Preview {
    PrivacyPolicyView()
}
