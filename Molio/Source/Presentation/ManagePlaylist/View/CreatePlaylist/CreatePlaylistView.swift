import SwiftUI

struct CreatePlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @ObservedObject var viewModel: ManagePlaylistViewModel

    var placeholder: String = "플레이리스트 이름을 입력해주세요"
    
    var dismissAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 40)
            
            Text("플레이리스트 만들기")
                .font(.custom(PretendardFontName.Bold, size: 28))
                .foregroundStyle(Color.white)
                        
            VStack {
                ZStack(alignment: .center) {
                    if text.isEmpty && !isFocused {
                        Text(placeholder)
                            .foregroundColor(.white)
                            .opacity(0.8)
                    }
                    
                    TextField("", text: $text)
                        .padding(.bottom, 5)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .font(.custom(PretendardFontName.Medium, size: 20))
                        .frame(height: 40)
                        .multilineTextAlignment(.center)
                        .focused($isFocused)
                }
                .frame(height: 40)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 40)
            
            HStack {
                BasicButton(type: .cancel) {
                    dismissAction?()
                }
                BasicButton(type: .confirm, isEnabled: !text.isEmpty) {
                    Task {
                        try await viewModel.createPlaylist(playlistName: text)
                        dismissAction?()
                    }
                }
            }
            .padding(.horizontal, 22)
            
            Spacer()
        }
    }

}

#Preview {
    CreatePlaylistView(viewModel: ManagePlaylistViewModel())
        .background(Color.background)
}

struct GlassmorphismBackground: View {
    var gradientColors: [Color] = [
        Color.white.opacity(0.23),
        Color.white.opacity(0.30),
        Color.white.opacity(0.25)
    ]
    var gradientStartPoint: UnitPoint = .topLeading
    var gradientEndPoint: UnitPoint = .bottomTrailing
    var blurRadius: CGFloat = 10.0

    var body: some View {
        ZStack {
            // 그라데이션 레이어
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: gradientStartPoint,
                endPoint: gradientEndPoint
            )
            .ignoresSafeArea()
            
            // 블러 효과
            Color.black
                .opacity(0.2) // 반투명 색상
                .blur(radius: blurRadius)
                .ignoresSafeArea()
        }
    }
}
