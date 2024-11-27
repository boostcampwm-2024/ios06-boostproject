import SwiftUI

struct ExportAppleMusicCompletionView: View {
    private let playlistName: String
    private let playlistLabelRadius: CGFloat = 13
    private let playlistLabelBlur: CGFloat = 85
    
    init(playlistName: String) {
        self.playlistName = playlistName
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image("appleMusicLogo")
                .resizable()
                .frame(width: 112, height: 112, alignment: .center)
                .padding(41)
            
            VStack(spacing: 5) {
                Text.molioMedium(playlistName, size: 16)
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background {
                        // TODO: - 정확한 효과
                        Color.white.opacity(0.8).blur(radius: playlistLabelBlur)
                            .cornerRadius(playlistLabelRadius)
                    }
                Text.molioSemiBold("플레이 리스트 생성 완료!", size: 21)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            BasicButton(type: .goToAppleMusic) {
                // TODO: - 애플 뮤직 이동
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 22)
        .padding(.bottom, 45)
        .background(Color.background)
    }
}

#Preview {
    ExportAppleMusicCompletionView(playlistName: "🎧 카공할 때 듣는 플리")
}
