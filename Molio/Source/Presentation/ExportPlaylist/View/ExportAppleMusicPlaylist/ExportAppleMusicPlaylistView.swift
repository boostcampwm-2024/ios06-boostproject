import SwiftUI

struct ExportAppleMusicPlaylistView: View {
    private let playlistLabelRadius: CGFloat = 13
    private let playlistLabelBlur: CGFloat = 85
    @ObservedObject private var viewModel: PlaylistDetailViewModel
    
    private var isProgressing: Bool {
        viewModel.exportStatus != .finished
    }
    
    var confirmButtonTapAction: (() -> Void)?
    
    init(viewModel: PlaylistDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            ExportPlatform.appleMusic.image
                .resizable()
                .frame(width: 112, height: 112, alignment: .center)
                .padding(41)
            
            VStack(spacing: 5) {
                Text.molioMedium(viewModel.currentPlaylist?.name ?? "molio 플레이리스트", size: 16)
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background {
                        // TODO: - 정확한 효과
                        Color.white.opacity(0.8).blur(radius: playlistLabelBlur)
                            .cornerRadius(playlistLabelRadius)
                    }
                HStack {
                    Text.molioSemiBold(viewModel.exportStatus.displayText, size: 21)
                    .foregroundStyle(.white)
                    
                    if isProgressing {
                        ProgressView()
                    }
                }
            }
            
            Spacer()
            
            BasicButton(type: .confirm, isEnabled: !isProgressing) {
                confirmButtonTapAction?()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 22)
        .padding(.bottom, 45)
        .onAppear {
            viewModel.exportMolioPlaylistToAppleMusic()
        }
    }
}

#Preview {
    ExportAppleMusicPlaylistView(viewModel: PlaylistDetailViewModel())
}
