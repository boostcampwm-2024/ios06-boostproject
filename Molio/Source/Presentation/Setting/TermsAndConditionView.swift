import SwiftUI

struct TermsAndConditionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    sectionView(
                        title: "제 1 조 (목적)",
                        content: """
                                    본 약관은 Molio(이하 "회사")가 제공하는 정보 제공 서비스(이하 "Molio")에 대해 회사와 정보 제공서비스를 이용하는 개인정보주체(이하 "이용자")간의 권리·의무 및 책임사항, 기타 필요한 사항 규정을 목적으로 합니다.
                                    """
                    )
                    sectionView(
                        title: "2. 개인정보의 처리 및 보유기간",
                        content: """
                                    회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.
                                    - 회원 가입 정보: 회원 탈퇴 시까지
                                    - 법령에 따른 보유기간
                                    """
                    )
                    sectionView(
                        title: "3. 개인정보의 제3자 제공",
                        content: """
                                    회사는 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.
                                    - 이용자가 사전에 동의한 경우
                                    - 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우
                                    """
                    )
                    sectionView(
                        title: "4. 개인정보의 파기절차 및 방법",
                        content: """
                                    회사는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다.
                                    파기절차 및 방법은 다음과 같습니다.
                                    - 파기절차: 불필요한 개인정보는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 파기
                                    - 파기방법: 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 파기
                                    """
                    )
                }
                Group {
                    sectionView(
                        title: "5. 이용자 및 법정대리인의 권리와 그 행사방법",
                        content: """
                                    이용자는 개인정보주체로서 다음과 같은 권리를 행사할 수 있습니다.
                                    - 개인정보 열람요구
                                    - 오류 등이 있을 경우 정정 요구
                                    - 삭제요구
                                    - 처리정지 요구
                                    """
                    )
                }
            }
            .padding()
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
    }
}

#Preview {
    TermsAndConditionView()
}
