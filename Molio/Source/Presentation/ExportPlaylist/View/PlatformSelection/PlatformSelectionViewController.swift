import SwiftUI

final class PlatformSelectionViewController: UIHostingController<PlatformSelectionView> {
    init(viewModel: PlaylistDetailViewModel) {
        let platformSelectionView = PlatformSelectionView(viewModel: viewModel)
        super.init(rootView: platformSelectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func continuePlaylistExport(to platform: ExportPlatform) {
        switch platform {
        case .appleMusic:
            print("애플뮤직 내보내기 화면 전환")
        case .image:
            print("이미지로 내보내기 화면 전환")
        }
    }
}
