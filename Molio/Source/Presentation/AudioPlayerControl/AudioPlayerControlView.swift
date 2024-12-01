import AVKit
import SwiftUI

struct AudioPlayerControlView: View {
    @EnvironmentObject private var viewModel: AudioPlayerControlViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.backwardButtonTapped()
            } label: {
                Image.molioRegular(systemName: "backward.fill", size: 24, color: .main)
            }
            
            Spacer()
            
            Button {
                viewModel.playButtonTapped()
            } label: {
                Image
                    .molioRegular(
                        systemName: viewModel.isPlaying ? "pause.fill" : "play.fill",
                        size: 24,
                        color: .main
                    )
            }
            
            Spacer()
            
            Button {
                viewModel.nextButtonTapped()
            } label: {
                Image.molioRegular(systemName: "forward.fill", size: 24, color: .main)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray, in: .capsule)
    }
}
