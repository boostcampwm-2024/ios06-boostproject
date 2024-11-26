import SwiftUI

final class PlaylistDetailViewController: UIHostingController<PlaylistDetailView> {
    // MARK: - Initializer
    
    init(viewModel: PlaylistDetailViewModel) {
        let playlistDetailView = PlaylistDetailView(viewModel: viewModel)
        super.init(rootView: playlistDetailView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .clear
        // TODO: - 뒤로가기 버튼 텍스트 숨기기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
